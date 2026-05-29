data "http" "grafana_healthcheck" {
  url = "aws_lb.app_alb.dns_name/grafana/api/health"

  retry {
    attempts     = 20
    min_delay_ms = 5000
    max_delay_ms = 10000
  }

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Grafana health check failed after retries"
    }
  }
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "AWS-CloudWatch"

  depends_on = [data.http.grafana_healthcheck]

  json_data_encoded = jsonencode({
    defaultRegion = "ap-southeast-1"
    authType      = "default"
  })
}

resource "grafana_dashboard" "ecs_metrics" {
  config_json = file("${path.module}/dashboards/ecs_fargate.json")

  depends_on = [grafana_data_source.cloudwatch]
}

import {
  to = module.monitoring.grafana_data_source.cloudwatch
  id = "AWS-CloudWatch"
}

import {
  to = module.monitoring.aws_lambda_permission.sns_trigger
  id = "Kelvin-Cloud-Project-discord-notifier/AllowExecutionFromSNS"
}