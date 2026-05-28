variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "target_group_arn_suffix" {
  type = string
}

variable "target_group_2_arn_suffix" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "alb_listener_rule_arn" {
  type        = string
  description = "ARN of the ALB listener rule for Grafana"
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the ALB"
}

variable "grafana_ready_signal" {
  type    = string
  default = ""
}