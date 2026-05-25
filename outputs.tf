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