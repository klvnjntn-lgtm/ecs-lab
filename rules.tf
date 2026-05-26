# Rules for the ALB
resource "aws_security_group_rule" "alb_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb.alb_sg_id
}

# The Connection (The fix for your 503!)
resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = module.ecs.ecs_sg_id
  security_group_id        = module.alb.alb_sg_id
}

resource "aws_security_group_rule" "ecs_from_alb" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = module.alb.alb_sg_id
  security_group_id        = module.ecs.ecs_sg_id
}

resource "aws_security_group_rule" "ecs_from_alb_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.alb.alb_sg_id
  security_group_id        = module.ecs.ecs_sg_id
}

resource "aws_security_group_rule" "alb_to_ecs_http" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.ecs.ecs_sg_id
  security_group_id        = module.alb.alb_sg_id
}

# This breaks the internet isolation wall and stops the ECR i/o timeout!
resource "aws_security_group_rule" "ecs_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1" # "-1" means ALL protocols
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ecs.ecs_sg_id # Attaches directly to your container group
}