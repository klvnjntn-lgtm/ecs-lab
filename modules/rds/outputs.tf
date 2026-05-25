output "db_instance_endpoint" {
  # Use .address instead of .endpoint if you want just the hostname (cleaner for some apps)
  value = aws_db_instance.postgres.address
}

# CHANGE THIS: Point to the SSM Parameter instead of Secrets Manager
output "db_password_ssm_arn" {
  value       = aws_ssm_parameter.db_password.arn
  description = "The ARN of the SSM parameter for the ECS task definition"
}