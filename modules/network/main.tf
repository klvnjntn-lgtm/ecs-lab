# 1. The VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "${var.project_name}-vpc" }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true # Critical for Fargate to pull images without a NAT

  tags = { Name = "${var.project_name}-public-subnet-${count.index + 1}" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project_name}-igw" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# 5. The Association
resource "aws_route_table_association" "public_assoc" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Note: Private Subnets and NAT Gateway deleted to save $30+/month.

# 6. The NAT Gateway (The "One-Way Mirror" for Private Subnets)
#resource "aws_eip" "nat" {
#domain = "vpc"
#tags   = { Name = "${var.project_name}-nat-eip" }
#}

#resource "aws_nat_gateway" "main" {
#allocation_id = aws_eip.nat.id
#subnet_id     = aws_subnet.public[0].id # NAT must live in Public
#tags          = { Name = "${var.project_name}-nat-gateway" }
##depends_on    = [aws_internet_gateway.gw]
#}

# 7. Private Route Table 
#resource "aws_route_table" "private_rt" {
#vpc_id = aws_vpc.main.id
#route {
#cidr_block     = "0.0.0.0/0"
#nat_gateway_id = aws_nat_gateway.main.id
#}
#}

#resource "aws_route_table_association" "private_assoc" {
#count          = length(var.availability_zones)
#subnet_id      = aws_subnet.private[count.index].id
#route_table_id = aws_route_table.private_rt.id
#}

resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id

  depends_on = [
    aws_iam_role_policy.vpc_flow_log_policy,
    aws_cloudwatch_log_group.vpc_log_group
  ]
}

resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "/aws/vpc/${var.project_name}-flow-logs"
  retention_in_days = 7
  lifecycle {
    create_before_destroy = true
  }
}