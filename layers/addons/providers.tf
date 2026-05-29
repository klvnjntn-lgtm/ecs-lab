# layers/addons/main.tf

# 1. Native Grafana Data Source Adoption
import {
  to = module.monitoring.grafana_data_source.cloudwatch
  # 🔴 FIX: Ensure this is the unique identifier (UID) string set inside Grafana
  id = "cloudwatch" 
}

# 2. Native Lambda Permission Adoption
import {
  to = module.monitoring.aws_lambda_permission.sns_trigger
  id = "Kelvin-Cloud-Project-discord-notifier/AllowExecutionFromSNS"
}

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
  url  = "http://${data.terraform_remote_state.infra.outputs.alb_dns_name}/grafana/"
  
  # 🔴 FIX: Use the Grafana Admin UI credentials, NOT the RDS Database credentials
  auth = "admin:KelvinSecurePass123!"
}