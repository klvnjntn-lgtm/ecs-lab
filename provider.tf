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
    key          = "eks/terraform.tfstate"
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

data "aws_secretsmanager_secret_version" "grafana_token" {
  secret_id = "Kelvin-Cloud-Project/grafana-token"
}

provider "grafana" {
  url  = "https://klvnjntn.grafana.net"
  auth = data.aws_secretsmanager_secret_version.grafana_token.secret_string
}

