output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_arn_suffix" {
  value = aws_lb.app_alb.arn_suffix
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "tg_arn_suffix" {
  value = aws_lb_target_group.app_tg_1.arn_suffix
}

output "tg_2_arn_suffix" {
  value = aws_lb_target_group.app_tg_2.arn_suffix
}

output "tg_1_arn" {
  value = aws_lb_target_group.app_tg_1.arn
}

output "tg_2_arn" {
  value = aws_lb_target_group.app_tg_2.arn
}

output "grafana_tg_arn" {
  value = aws_lb_target_group.grafana_tg.arn
}