# 0. Generate a random password (The "Engineer" Move)
resource "random_password" "db_pass" {
  length           = 16
  special          = true
  override_special = "_%!" # Avoiding characters that can break connection strings
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.project_name}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_sg_id]
    
    # 🟢 ADD THIS LINE: Allows internal VPC subnets to communicate on port 5432
    cidr_blocks     = ["10.0.0.0/16"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = lower("${var.project_name}-db-subnet-group")
  subnet_ids = var.subnet_ids

  tags = { Name = "${var.project_name}-db-subnet-group" }
}

# 3. The Database Instance
resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  db_name                = "myappdb"
  username               = "dbadmin"
  
  # Use the generated password
  password               = random_password.db_pass.result 
  
  parameter_group_name   = "default.postgres15"
  skip_final_snapshot    = true
  multi_az               = var.multi_az_enabled
  publicly_accessible    = false 
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = { Name = "${var.project_name}-db" }
}

# 4. SSM Parameter (Storing the secret automatically)
resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.project_name}/db-password"
  description = "RDS password for ECS"
  type        = "SecureString"
  
  # Source the value from the random generator
  value       = random_password.db_pass.result 

  tags = { Name = "${var.project_name}-db-password" }
}