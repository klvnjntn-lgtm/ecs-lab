resource "time_sleep" "wait_for_grafana" {
  create_duration = "60s"  # Gives Grafana a full minute to complete database migrations
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "AWS-CloudWatch"
  depends_on = [time_sleep.wait_for_grafana]

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

