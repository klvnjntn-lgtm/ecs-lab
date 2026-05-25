variable "project_name" {
  type        = string
  default     = "Kelvin-Cloud-Project"
  description = "The prefix for all resources in this project"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs to deploy into"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for the public subnets"
}

#variable "private_subnet_cidrs" {
#type        = list(string)
#description = "CIDR blocks for the private subnets"
#}

variable "monthly_budget_limit" {
  default = "10.0"
}

variable "container_name" {
  type    = string
  default = "my-app-container"
}

variable "region" {
  type    = string
  default = "ap-southeast-1"
}

