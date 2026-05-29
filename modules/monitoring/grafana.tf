resource "time_sleep" "wait_for_grafana" {
  # 🟢 Increased to 90s to guarantee the ALB targets clear their health checks
  create_duration = "90s"  
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "AWS-CloudWatch" # 🔴 Note this name string
  
  # 🟢 Native meta-arguments belong directly inside the resource block, NOT inside jsonencode
  depends_on = [
    time_sleep.wait_for_grafana,
    var.grafana_ready_signal
  ]

  json_data_encoded = jsonencode({
    defaultRegion = "ap-southeast-1"
    authType      = "default"
  })
}

resource "grafana_dashboard" "ecs_metrics" {
  config_json = file("${path.module}/dashboards/ecs_fargate.json")

  depends_on = [grafana_data_source.cloudwatch]
}

# --- IMPORT ALIGNMENT FIXES ---

import {
  to = module.monitoring.grafana_data_source.cloudwatch
  
  # 🟢 FIX: This MUST match the exact string value of the "name" attribute above!
  id = "AWS-CloudWatch" 
}

import {
  to = module.monitoring.aws_lambda_permission.sns_trigger
  id = "Kelvin-Cloud-Project-discord-notifier/AllowExecutionFromSNS"
}