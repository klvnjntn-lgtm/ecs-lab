# layers/addons/main.tf

terraform {
  required_version = ">= 1.0"

  # 1. WHERE ADDONS WRITES ITS STATE (This keeps it separate from infra!)
  backend "s3" {
    bucket         = "kelvin-terraform-state-permanent"
    key            = "addons/terraform.tfstate" 
    region         = "ap-southeast-1"
  }

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

# 2. WHERE ADDONS READS FROM INFRA (Your read-only lens)
data "terraform_remote_state" "infra" {
  backend = "s3" 
  config = {
    bucket = "kelvin-terraform-state-permanent"
    
    # CRITICAL: This key MUST match the exact backend key specified inside layers/infra/main.tf
    key    = "ecs/terraform.tfstate" 
    
    region = "ap-southeast-1"
  }
}

provider "grafana" {
  url  = "http://${data.terraform_remote_state.infra.outputs.alb_dns_name}/grafana/"
  auth = "admin:KelvinSecurePass123!"
}