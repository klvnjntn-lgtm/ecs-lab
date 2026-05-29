module "monitoring" {
  source                    = "../../modules/monitoring"
  
  # Fix: Route all arguments to look inside data.terraform_remote_state.infra.outputs
  project_name              = data.terraform_remote_state.infra.outputs.project_name
  alb_arn_suffix            = data.terraform_remote_state.infra.outputs.alb_arn_suffix
  target_group_arn_suffix   = data.terraform_remote_state.infra.outputs.tg_arn_suffix
  target_group_2_arn_suffix = data.terraform_remote_state.infra.outputs.tg_2_arn_suffix
  alb_listener_rule_arn     = data.terraform_remote_state.infra.outputs.alb_listener_rule_monitoring_arn
  alb_dns_name              = data.terraform_remote_state.infra.outputs.alb_dns_name
  grafana_url             = data.terraform_remote_state.infra.outputs.alb_dns_name
  # ...
  # Since you deleted the grafana_ready check resource from the ECS layer, 
  # pass a dummy value or a null string if the module variable accepts it, 
  # or remove this line if you updated the monitoring module variables.
  grafana_ready_signal      = "ready" 
}