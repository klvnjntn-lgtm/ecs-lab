# modules/monitoring/providers.tf (or append to main.tf)
terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "AWS-CloudWatch"

  json_data_encoded = jsonencode({
    defaultRegion = "ap-southeast-1"
authType      = "default"
depends_on = [var.grafana_ready_signal]
  })
}

resource "grafana_dashboard" "ecs_metrics" {
  config_json = file("${path.module}/dashboards/ecs_fargate.json")

depends_on = [grafana_data_source.cloudwatch]
}

