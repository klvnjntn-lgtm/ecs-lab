resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.public_subnet_ids

  tags = { Name = "${var.project_name}-alb" }
}

resource "aws_lb_target_group" "app_tg_1" {
  name        = "${var.project_name}-tg-1"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "app_tg_2" {
  name        = "${var.project_name}-tg-2"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg_1.arn
  }
}

resource "aws_lb_listener" "test" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "8080" 
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg_2.arn
  }
}

resource "aws_lb_target_group" "grafana_tg" {
  name        = "${var.project_name}-grafana-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/api/health"
    matcher             = "200"
  }
}

resource "aws_lb_listener_rule" "monitoring" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10 # Higher priority than the default rule

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana_tg.arn # The new Port 3000 TG
  }

  condition {
    path_pattern {
      values = ["/grafana", "/grafana/*"]
    }
  }
}
