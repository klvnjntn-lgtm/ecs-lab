<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_execution_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs_execution_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_sg_id"></a> [alb\_sg\_id](#input\_alb\_sg\_id) | The Security Group ID of the ALB (to allow traffic into ECS) | `string` | n/a | yes |
| <a name="input_db_endpoint"></a> [db\_endpoint](#input\_db\_endpoint) | The endpoint of the RDS instance | `string` | n/a | yes |
| <a name="input_db_password_secret_arn"></a> [db\_password\_secret\_arn](#input\_db\_password\_secret\_arn) | The ARN of the Secrets Manager secret for the DB password | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name for resource naming | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Subnets where the Fargate tasks will run | `list(string)` | n/a | yes |
| <a name="input_repository_url"></a> [repository\_url](#input\_repository\_url) | The ECR repository URL for the task definition | `string` | n/a | yes |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | Blue Target Group | `string` | n/a | yes |
| <a name="input_target_group_arn_2"></a> [target\_group\_arn\_2](#input\_target\_group\_arn\_2) | Green Target Group | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the ECS Security Group will live | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_ecs_sg_id"></a> [ecs\_sg\_id](#output\_ecs\_sg\_id) | n/a |
| <a name="output_execution_role_arn"></a> [execution\_role\_arn](#output\_execution\_role\_arn) | Outputs |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | n/a |
| <a name="output_task_role_arn"></a> [task\_role\_arn](#output\_task\_role\_arn) | n/a |
<!-- END_TF_DOCS -->