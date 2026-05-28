terraform {
  # 1. Add the Grafana provider to your required_providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket       = "kelvin-terraform-state-permanent"
    key          = "ecs/terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
    encrypt      = true
    dynamodb_table = "terraform-state-locking-permanent"
  }
}

provider "aws" {
  region = "ap-southeast-1"

  default_tags {
    tags = {
      Project     = "Fargate-Migration"
      Owner       = "Kelvin"
      ManagedBy   = "Terraform"
      Environment = "Dev"
    }
  }
}

provider "grafana" {
  url  = "http://${module.alb.alb_dns_name}/grafana/"
  
  # 🚀 Dynamic Admin Auth using your RDS configurations:
  # This uses the exact same username and password your RDS module generated!
  auth = "dbadmin:${module.rds.rds_password}"
}
