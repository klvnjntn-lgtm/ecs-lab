# 🚀 AWS architecture designed to survive real-world failure scenarios (container crashes, AZ outages, failed health checks) (ECS Fargate)

## Overview

This project demonstrates a resilient, production-style AWS architecture designed to handle real-world failure scenarios while maintaining high availability and observability.

Built using managed AWS services, the system minimizes operational overhead while ensuring scalability, fault tolerance, and cost awareness.

[Infrastructure](docs/infrastructure.md)

---

## Request Flow

![DIAGRAM](https://github.com/klvnjntn-lgtm/cloud-infrastructure-project-kj/blob/main/docs/AWS-DIAGRAM.png)

Traffic flows through a multi-layered architecture designed for isolation, resilience, and controlled exposure.

---

## 🏗️ System Architecture

Managed, Multi-AZ infrastructure designed for 99.9% availability and automated recovery.

Key Highlights
High Availability: Multi-AZ ECS Fargate + RDS Failover.

Security: Private networking, IAM least-privilege, and SSM Secrets.

Full observability pipeline (CloudWatch metrics, logs, alarms) with real-time incident alerts pushed to Discord

---

## 🧭 Architecture Summary

Client → Internet Gateway → ALB → ECS (Fargate) → RDS (Multi-AZ)

- **ALB** distributes traffic across multiple AZs
- **ECS Fargate** runs containers with self-healing
- **RDS Multi-AZ** ensures database failover
- **Private subnets + NAT Gateway** secure outbound access

---

## 🧱 Core Features

- Multi-AZ deployment for high availability  
- Automatic container recovery (self-healing)  
- Health check-based traffic routing  
- Centralized logging and monitoring  
- Real-time alerting to Discord  
- Infrastructure as Code using Terraform  

---

## ⚙️ Tech Stack
- Compute: ECS Fargate  
- Load Balancing: Application Load Balancer  
- Database: Amazon RDS (Multi-AZ)  
- Networking: VPC, Subnets, IGW, NAT Gateway  
- Monitoring: CloudWatch  
- Alerts: SNS + Lambda → Discord  
- Container Registry: ECR  

---

## 💥 Challenges and Solutions

Some of the noteable challenges I've encountered so far through creating this project

[Challenges](docs/challenges.md)

---

## 🔍 Observability
- Metrics: CPU, memory, latency, request count  
- Logs: Centralized via CloudWatch Logs  
- Alerts: Threshold-based alarms with real-time notifications  

`CloudWatch Alarm` → `SNS Topic` → `Lambda` → `Discord Webhook`

---

## 🔐 Production Hardening
- Secrets managed via SSM Secrets Manager  
- IAM roles follow least privilege principle  
- HTTPS enforced using ACM + ALB  
- Optional WAF for application-layer protection  
- RDS Proxy for connection stability  
- VPC Endpoints reduce NAT usage (cost optimization)  

---

## 🔐 Secrets Management

Sensitive data is stored using SSM Parameter Store and injected at runtime — no hardcoded credentials.

---

## 🔄 CI/CD Pipeline

GitHub Push
→ GitHub Actions builds Docker image
→ Image pushed to Amazon ECR
→ ECS service updated (rolling deployment)

Deployment Strategy:
- Zero-downtime rolling updates
- Health checks ensure only healthy containers receive traffic

---

## 💸 Cost Optimization

- Pay-as-you-go compute (Fargate)  
- NAT Gateway minimized via VPC endpoints  
- Budget alerts configured via AWS Budgets  

---

## 🚀 Deployment

```bash
terraform init
terraform plan
terraform apply
```

[Installation Guide](docs/installation.md)

---

## 🔄 Deployment Strategy (ECS Native Blue-Green)

Implemented blue-green-style deployments using ECS and ALB without CodeDeploy.

- Two target groups (Blue / Green)
- New version deployed to inactive target group
- Traffic switched via ALB after health checks pass
- Allows rollback by reverting target group

Trade-off:
- More manual control
- Lacks automated traffic shifting (as provided by CodeDeploy)

## 📌 Future Improvements
- Grafana dashboards for visualization  
- Advanced autoscaling tuning  
- Canary deployments  

[Future Projects](docs/future-projects.md)

---

## 📊 Why ECS over Kubernetes
- Lower complexity  
- Faster iteration  
- Better cost efficiency at smaller scale  

Tradeoff: Less flexibility than Kubernetes

---

## 🧠 Key Takeaway
This project focuses on building a fault-tolerant, production-ready system using managed services, balancing reliability, simplicity, and cost.

---


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.100.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ./modules/alb | n/a |
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ./modules/ecr | n/a |
| <a name="module_ecs"></a> [ecs](#module\_ecs) | ./modules/ecs | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/monitoring | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_rds"></a> [rds](#module\_rds) | ./modules/rds | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_budgets_budget.monthly_limit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget) | resource |
| [aws_iam_policy.enforce_mfa](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy.ecs_task_secrets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of AZs to deploy into | `list(string)` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | n/a | `string` | `"my-app-container"` | no |
| <a name="input_monthly_budget_limit"></a> [monthly\_budget\_limit](#input\_monthly\_budget\_limit) | n/a | `string` | `"10.0"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The prefix for all resources in this project | `string` | `"Kelvin-Cloud-Project"` | no |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | CIDR blocks for the public subnets | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_target_groups"></a> [active\_target\_groups](#output\_active\_target\_groups) | n/a |
| <a name="output_alb_public_url"></a> [alb\_public\_url](#output\_alb\_public\_url) | The public URL to access Kelvin's Web Server |
| <a name="output_container_name"></a> [container\_name](#output\_container\_name) | n/a |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | n/a |
| <a name="output_ecs_service_name"></a> [ecs\_service\_name](#output\_ecs\_service\_name) | n/a |
| <a name="output_ecs_task_definition_family"></a> [ecs\_task\_definition\_family](#output\_ecs\_task\_definition\_family) | n/a |
<!-- END_TF_DOCS -->
