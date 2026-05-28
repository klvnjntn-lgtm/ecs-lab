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