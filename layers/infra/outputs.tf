output "alb_public_url" {
  description = "The public URL to access Kelvin's Web Server"
  value = "http://${module.alb.alb_dns_name}"
}

output "active_target_groups" {
  value = [
    module.alb.tg_1_arn,
    module.alb.tg_2_arn
  ]
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "ecs_task_definition_family" {
  value = module.ecs.task_definition_family
}

output "container_name" {
  value = var.container_name
}

# layers/infra/outputs.tf

output "project_name" {
  value       = var.project_name # or whatever variable/local holds your project name
  description = "The name of the project"
}

output "alb_dns_name" {
  value       = module.alb.alb_dns_name # Verify this matches your ALB module name
  description = "The public DNS name of the Application Load Balancer"
}

output "alb_arn_suffix" {
  value       = module.alb.alb_arn_suffix
}

output "tg_arn_suffix" {
  value       = module.alb.tg_arn_suffix
}

output "tg_2_arn_suffix" {
  value       = module.alb.tg_2_arn_suffix
}

output "alb_listener_rule_monitoring_arn" {
  value       = module.alb.alb_listener_rule_monitoring_arn
}

output "rds_password" {
  value       = module.rds.rds_password # Verify this matches your RDS module output name
  sensitive   = true # Prevents the password from printing in clear text during pipeline logs
}