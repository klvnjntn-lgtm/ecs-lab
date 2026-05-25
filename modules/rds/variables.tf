variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "ecs_sg_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "multi_az_enabled" {
  type    = bool
  default = false # Set to true when you want to show off
}