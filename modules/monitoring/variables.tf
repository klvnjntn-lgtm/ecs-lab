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

variable "grafana_url" {
  type        = string
  description = "The URL of the Grafana Cloud instance"
  default     = "https://klvnjntn.grafana.net"
}

variable "grafana_token" {
  type        = string
  description = "The Service Account token for Grafana"
  sensitive   = true
  default     = "INSERT_TOKEN_HERE"
}