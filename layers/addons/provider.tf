data "terraform_remote_state" "infra" {
  backend = "s3" 
  config = {
    bucket = "kelvin-terraform-state-permanent"
    key    = "infra/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

provider "grafana" {
  # Fix: Read from the remote state instead of module.alb
  url  = "http://${data.terraform_remote_state.infra.outputs.alb_dns_name}/grafana/"
  
  # Fix: Read from the remote state instead of module.rds
  auth = "dbadmin:${data.terraform_remote_state.infra.outputs.rds_password}"
}