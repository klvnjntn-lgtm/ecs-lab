resource "aws_iam_role_policy" "ecs_task_secrets_policy" {
  name = "${var.project_name}-task-secrets-policy"
  role = module.ecs.task_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["secretsmanager:GetSecretValue"]
      Effect   = "Allow"
      Resource = [module.rds.db_password_ssm_arn]
    }]
  })
}