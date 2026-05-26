resource "grafana_folder" "project_monitoring" {
  title      = "Project Monitoring"
  depends_on = [null_resource.wait_for_grafana] # Wait for the health check to pass
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "AWS-CloudWatch"
  depends_on = [grafana_folder.project_monitoring]

  json_data_encoded = jsonencode({
    defaultRegion = "ap-southeast-1"
    authType      = "arn"
    assumeRoleArn = "arn:aws:iam::123456789012:role/YourGrafanaRole" 
  })
}

resource "grafana_dashboard" "ecs_metrics" {
  folder      = grafana_folder.project_monitoring.id
  config_json = file("${path.module}/dashboards/ecs_fargate.json")
}

