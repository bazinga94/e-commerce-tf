# resource "aws_iam_role_policy" "admin" {

# }

# data "aws_iam_policy_document" "admin" {
#   statement {
#     actions = ["s3:*","ec2:*","rds:*"]
#     resources = ["*"]
#     effect = "Allow"
#   }
# }

# data "aws_iam_policy_document" "webserver" {
#   statement {
#     actions = [ "ec2:*", "rds:DescribeDBClusters",
#                 "rds:DescribeDBInstances", "secretsmanager:GetSecretValue" ]
#   }
# }

# data "aws_iam_policy_document" "webserver" {
#     statement {
#       actions = ["secretsmanager:GetSecretValue"]
#       resources = [aws_secretsmanager_secret.rds.arn]
#       effect = "Allow"
#     }
  
# }