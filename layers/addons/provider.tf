data "terraform_remote_state" "infra" {
  backend = "s3" 
  config = {
    bucket = "kelvin-terraform-state-permanent"
    
    # FIX: Change this from "infra/terraform.tfstate" to match your infra backend key
    key    = "ecs/terraform.tfstate" 
    
    region = "ap-southeast-1"
  }
}

# layers/addons/main.tf (at the very top)
terraform {
  required_version = ">= 1.0"
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

provider "grafana" {
  # Fix: Read from the remote state instead of module.alb
  url  = "http://${data.terraform_remote_state.infra.outputs.alb_dns_name}/grafana/"
  
  # Fix: Read from the remote state instead of module.rds
  auth = "dbadmin:${data.terraform_remote_state.infra.outputs.rds_password}"
}