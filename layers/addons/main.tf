module "monitoring" {
  source                  = "../../modules/monitoring"
  project_name            = data.project_name
  alb_arn_suffix          = data.alb_arn_suffix
  target_group_arn_suffix = data.alb.tg_arn_suffix
  target_group_2_arn_suffix = data.alb.tg_2_arn_suffix
  alb_listener_rule_arn = data.alb.alb_listener_rule_monitoring_arn
  alb_dns_name = data.alb.alb_dns_name
  grafana_ready_signal = data.ecs.ecs_service_ready
}