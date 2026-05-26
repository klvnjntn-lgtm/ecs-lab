resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "AWS-CloudWatch"

  json_data_encoded = jsonencode({
    defaultRegion = "ap-southeast-1"
    authType      = "arn"
    assumeRoleArn = "arn:aws:iam::123456789012:role/YourGrafanaRole" 
  })
}

resource "grafana_dashboard" "ecs_metrics" {
  config_json = file("${path.module}/dashboards/ecs_fargate.json")
}

