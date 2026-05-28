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

variable "alb_dns_name" {
  type        = string
  description = "The DNS name of the Application Load Balancer"
}

variable "rds_address" {
  type        = string
  description = "The address of the RDS instance (e.g., your_rds_instance.endpoint:5432)"
}

variable "rds_password" {
  type        = string
  description = "The password for the RDS database passed from the RDS module"
  sensitive   = true
}

variable "rds_db_name" {
  type        = string
  description = "The name of the RDS database"
}

variable "rds_username" {
  type        = string
  description = "The username for the RDS database"
}