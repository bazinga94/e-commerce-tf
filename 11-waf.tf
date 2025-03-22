resource "aws_wafv2_web_acl" "waf_acl" {
  name        = "web-acl"
  description = "WAF for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "BlockBadBots"
    priority = 1

    action {
      block {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          uri_path {}
        }
        positional_constraint = "CONTAINS"
        search_string         = "/admin"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockBadBots"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "web-acl-metrics"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_regex_pattern_set" "bad_inputs" {
  name  = "bad-inputs-pattern"
  scope = "REGIONAL"

  regular_expression {
    regex_string = "(?i)(select\\s.*from|union\\s+select|<script>|javascript:|alert\\(|document\\.cookie)"
  }

  tags = {
    Name = "bad-inputs-pattern"
  }
}

resource "aws_wafv2_web_acl_association" "waf_assoc" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf_acl.arn

  depends_on = [ aws_wafv2_web_acl.waf_acl, aws_instance.webserver ]
}
