variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the ECS Security Group will live"
}

variable "public_subnets" {
  type        = list(string)
  description = "Subnets where the Fargate tasks will run"
}

variable "repository_url" {
  type        = string
  description = "The ECR repository URL for the task definition"
}

variable "target_group_arn" {
  type        = string
  description = "Blue Target Group"
}

variable "target_group_arn_2" {
  type        = string
  description = "Green Target Group"
}

variable "alb_sg_id" {
  type        = string
  description = "The Security Group ID of the ALB (to allow traffic into ECS)"
}

variable "db_endpoint" {
  type        = string
  description = "The endpoint of the RDS instance"
}

variable "db_password_ssm_arn" {
  type        = string
  description = "The ARN of the SSM Parameter where the DB password is stored"
}

variable "container_name" {
  type    = string
  default = "my-app-container"
}

variable "grafana_tg_arn" {
  description = "ARN of the Grafana Target Group"
  type        = string
}