variable "project_name" {
  type    = string
  default = "Kelvin-Cloud-Project"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs for high availability"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the public subnets"
}

#variable "private_subnet_cidrs" {
#type        = list(string)
#description = "CIDR blocks for the private subnets"
#}
