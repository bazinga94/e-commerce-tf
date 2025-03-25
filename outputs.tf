output "rds_endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "rds_password" {
  value = random_password.rds.result
  sensitive = true
}

output "loadbalancer_endpoint" {
  value = aws_lb.alb.dns_name
}

output "jmeter_public_ip" {
  value = aws_instance.jmeter.public_ip
}

output "sns_topic_arn" {
  value = aws_sns_topic.alerts.arn
}