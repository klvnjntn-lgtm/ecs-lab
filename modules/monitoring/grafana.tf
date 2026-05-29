resource "time_sleep" "grafana_boot_delay" {
  create_duration = "90s"  
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "AWS-CloudWatch"
  
  # 🟢 FIX: Update the dependency to match the new timer name
  depends_on = [
    time_sleep.grafana_boot_delay,
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