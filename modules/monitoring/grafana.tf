resource "time_sleep" "wait_for_grafana" {
  create_duration = "60s" # Gives Grafana time to boot up behind the ALB
}
resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "AWS-CloudWatch"
  # Keep your lifecycle dependencies grouped together here at the root level
  depends_on = [
    time_sleep.wait_for_grafana
  ]
  # Clean JSON payload containing ONLY settings Grafana's API expects
  json_data_encoded = jsonencode({
    defaultRegion = "ap-southeast-1"
    authType      = "default"
  })
}
resource "grafana_dashboard" "ecs_metrics" {
  # Ensure this JSON file contains actual data inside the "panels" array
  config_json = file("${path.module}/dashboards/ecs_fargate.json")
  depends_on = [grafana_data_source.cloudwatch]
}
