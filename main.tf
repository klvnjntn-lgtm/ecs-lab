module "network" {
  source              = "./modules/network"
  project_name        = "Kelvin-Cloud-Project"
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  region              = var.region
}

module "alb" {
  source            = "./modules/alb"
  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  ecs_sg_id        = module.ecs.ecs_sg_id
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
}

module "rds" {
  source       = "./modules/rds"
  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  ecs_sg_id    = module.ecs.ecs_sg_id
  subnet_ids   = module.network.public_subnet_ids
}

module "ecs" {
  source             = "./modules/ecs"
  project_name       = var.project_name
  container_name = var.container_name
  repository_url     = module.ecr.repository_url
  vpc_id             = module.network.vpc_id
  public_subnets     = module.network.public_subnet_ids
  alb_sg_id          = module.alb.alb_sg_id
  target_group_arn   = module.alb.tg_1_arn
  target_group_arn_2 = module.alb.tg_2_arn
  db_endpoint            = module.rds.db_instance_endpoint
  db_password_ssm_arn = module.rds.db_password_ssm_arn
  grafana_tg_arn     = module.alb.grafana_tg_arn
  alb_dns_name       = module.alb.alb_dns_name
}

module "monitoring" {
  source                  = "./modules/monitoring"
  project_name            = var.project_name
  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.tg_arn_suffix
  target_group_2_arn_suffix = module.alb.tg_2_arn_suffix
  alb_listener_rule_arn = module.alb.alb_listener_rule_monitoring_arn
  alb_dns_name = module.alb.alb_dns_name
}