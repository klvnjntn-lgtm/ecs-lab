# --- Discord Webhook Storage ---
resource "aws_ssm_parameter" "discord_webhook" {
  name        = "/${var.project_name}/discord-webhook"
  description = "Discord Webhook URL for alerts"
  type        = "SecureString"
  value       = "INSERT_WEBHOOK_URL_HERE" 

  lifecycle {
    ignore_changes = [value]
  }
}

# --- Notification Channel ---
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alerts"
}

# --- CloudWatch Alarms ---
resource "aws_cloudwatch_metric_alarm" "tg1_unhealthy" {
  alarm_name          = "${var.project_name}-tg1-unhealthy"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "Triggered when Target Group 1 tasks fail health checks."

  dimensions = {
    TargetGroup  = var.target_group_arn_suffix
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "tg2_unhealthy" {
  alarm_name          = "${var.project_name}-tg2-unhealthy"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "Triggered when Target Group 2 tasks fail health checks."

  dimensions = {
    TargetGroup  = var.target_group_2_arn_suffix
    LoadBalancer = var.alb_arn_suffix
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

# --- Discord Notifier (Lambda) ---
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/discord_notifier.py"
  output_path = "${path.module}/lambda/discord_notifier.zip"
}

resource "aws_lambda_function" "discord_alert" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "${var.project_name}-discord-notifier"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "discord_notifier.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      WEBHOOK_PARAMETER_NAME = aws_ssm_parameter.discord_webhook.name
    }
  }
}

resource "aws_lambda_permission" "sns_trigger" {
  statement_id  = "AllowExecutionFromSNS"
  action         = "lambda:InvokeFunction"
  function_name = aws_lambda_function.discord_alert.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alerts.arn
}

resource "aws_sns_topic_subscription" "lambda_subs" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.discord_alert.arn
}