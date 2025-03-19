resource "aws_wafv2_web_acl" "waf" {

  name = "${var.basename}-waf"
  scope = "CLOUDFRONT"

  default_action {
    allow {
    }
  }

  rule {
    name = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name = "AWS-AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    action {
      block {}
    }
    visibility_config {
  cloudwatch_metrics_enabled = true
  metric_name = "AWS-AWSManagedRulesCommonRuleSet"
  sampled_requests_enabled = true
    }
  }
  rule {
    name = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 2
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name = "AWS-AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    action {
      allow {}
    }
    visibility_config {
  cloudwatch_metrics_enabled = true
  metric_name = "AWS-AWSManagedRulesSQLiRuleSet"
  sampled_requests_enabled = true
   }
  }  
  visibility_config {
  cloudwatch_metrics_enabled = true
  metric_name = "${var.basename}-waf"
  sampled_requests_enabled = true
 }

 tags = {
   Name = "${var.basename}-waf-rules"
 }
}

resource "aws_wafv2_web_acl_association" "waf_alb" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn = aws_wafv2_web_acl.waf.arn
}

