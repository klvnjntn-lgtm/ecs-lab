

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
#

resource "aws_iam_policy" "enforce_mfa" {
  name        = "EnforceMFAPolicy"
  description = "Denies everything if MFA is not active"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowViewAccountInfoAndManageOwnMFA"
        Effect = "Allow"
        Action = [
          "iam:GetAccountPasswordPolicy",
          "iam:GetAccountSummary",
          "iam:ListVirtualMFADevices",
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenyAllExceptMFA"
        Effect = "Deny"
        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "iam:GetUser",
          "sts:GetSessionToken"
        ]
        Resource = "*"
        Condition = {
          "BoolIfExists" = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}