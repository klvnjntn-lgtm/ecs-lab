resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name         = var.container_name
      image        = "${var.repository_url}:latest"
      essential    = true
      portMappings = [{ containerPort = 80, hostPort = 80, protocol = "tcp" }]
    },
    {
      name         = "grafana"
      image        = "grafana/grafana:latest"
      essential    = false
      linuxParameters = {
        initProcessEnabled = true
      }
      portMappings = [{ containerPort = 3000, hostPort = 3000, protocol = "tcp" }]
      environment = [
        { name = "GF_SERVER_ROOT_URL", value = "http://${var.alb_dns_name}/grafana/" },
        { name = "GF_SERVER_SERVE_FROM_SUB_PATH", value = "true" },
        { name = "GF_SESSION_COOKIE_PATH", value = "/grafana/" },
        { name = "GF_SESSION_COOKIE_SECURE", value = "false" },
        { name = "GF_SECURITY_COOKIE_SAMESITE", value = "lax" },
        { name = "GF_SECURITY_ADMIN_USER", value = "admin" },
        { name = "GF_SECURITY_ADMIN_PASSWORD", value = "KelvinSecurePass123!" },
        { name = "GF_DATABASE_TYPE", value = "postgres" },
        { name = "GF_DATABASE_HOST", value = split(":", var.rds_address)[0] }, 
        
        # 🟢 FIX: Removed literal quotes so Terraform parses the actual variables
        { name = "GF_DATABASE_NAME", value = var.rds_db_name },       
        { name = "GF_DATABASE_USER", value = var.rds_username },       
        { name = "GF_DATABASE_PASSWORD", value = "rds123!" }
      ] # 🟢 FIX: Added a comma here to cleanly separate the block parameters
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
          "awslogs-region"        = "ap-southeast-1"
          "awslogs-stream-prefix" = "grafana"
        }
      }
    }
  ])
}

resource "aws_security_group" "ecs_sg" {
  name   = "${var.project_name}-ecs-sg"
  vpc_id = var.vpc_id
}

resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

provisioner "local-exec" {
    command = "echo 'Waiting for Grafana to run RDS migrations and clear ALB health checks...' && sleep 150"
  }

  deployment_controller {
    type = "ECS"
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = var.container_name
    container_port   = 80
  }

  load_balancer {
    target_group_arn = var.grafana_tg_arn
    container_name   = "grafana" # Must match the name in container_definitions
    container_port   = 3000
  }
}