output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name 
}

output "service_name" {
  value = aws_ecs_service.main.name
}

output "execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "task_role_name" {
  description = "The name of the ECS task role for the root IAM policy"
  value       = aws_iam_role.ecs_task_role.name
}

output "task_role_arn" {
  description = "The ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "task_definition_family" {
  value = aws_ecs_task_definition.app.family
}

output "container_name" {
  value = var.container_name
}