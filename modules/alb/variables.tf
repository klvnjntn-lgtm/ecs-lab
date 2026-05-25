variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB"
}

variable "ecs_sg_id" {
  type        = string
  description = "ID of the ECS security group"
}