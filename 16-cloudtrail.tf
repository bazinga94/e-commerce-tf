# resource "aws_s3_bucket" "cloudtrail_logs" {
#   bucket = "my-cloudtrail-logs-bucket"
#
#   lifecycle_rule {
#     enabled = true
#     expiration {
#       days = 365
#     }
#   }
# }
#
# resource "aws_cloudtrail" "security_trail" {
#   name           = "security-trail"
#   s3_bucket_name = aws_s3_bucket.cloudtrail_logs.id # Need to change to real s3 id
#
#   include_global_service_events = true
#   enable_logging = true
# }

# resource "aws_cloudtrail" "main" {
#   name                          = "main-trail"
#   s3_bucket_name                = "my-cloudtrail-logs-bucket"
#   is_multi_region_trail         = true
#   include_global_service_events = true
#   enable_logging                = true
#   # depends_on                  = [aws_s3_bucket.cloudtrail_logs_bucket]
# }

# resource "aws_s3_bucket" "cloudtrail_logs_bucket" {
#   bucket = "my-cloudtrail-logs-bucket"
#   acl    = "private"
# }
