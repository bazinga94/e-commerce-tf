resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name          = "EC2-CPU-Utilization"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 300
  evaluation_periods  = 1
  threshold           = 80
  comparison_operator = "GreaterThanThreshold"
  alarm_description   = "Alarm when EC2 CPU exceeds 80% utilization"
  dimensions = {
    InstanceId = aws_instance.webserver["subnet-az1"].id  # EC2 인스턴스 ID 참조 (subnet-az1을 예시로 사용)
  }
}


resource "aws_cloudwatch_metric_alarm" "rds_high_cpu" {
  alarm_name          = "rds-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 75  # 75% CPU usage
  alarm_description   = "Triggers when RDS CPU usage exceeds 75%"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions         = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.rds.id
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_high_latency" {
  alarm_name          = "rds-high-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 100 # 100 connections
  alarm_description   = "Triggers when RDS query latency exceeds threshold"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.rds.id
  }
}

resource "aws_sns_topic" "alerts" {
  name = "rds-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "your-email@example.com" # email to receive alert
}

resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/aws/ec2/jmeter-testing"
  retention_in_days = 7
}

resource "aws_cloudwatch_dashboard" "monitoring_dashboard" {
  for_each = aws_instance.webserver  # iterate each webserver instance

  dashboard_name = "JMeterMonitoringDashboard-${each.key}"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 6,
      "height": 6,
      "properties": {
        "metrics": [
          [ "AWS/EC2", "CPUUtilization", "InstanceId", "${each.value.id}" ],
          [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${aws_db_instance.rds.id}" ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "us-east-1",
        "title": "EC2 & RDS CPU Usage"
      }
    }
  ]
}
EOF
}


resource "aws_iam_policy" "cost_explorer_policy" {
  name        = "CostExplorerAccess"
  description = "Allows access to AWS Cost Explorer"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ce:GetCostAndUsage",
                "ce:GetReservationUtilization"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}