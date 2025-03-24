resource "random_password" "rds" {
  length           = 16
  special         = true
}

resource "aws_secretsmanager_secret" "rds" {
  name = "${var.basename}-rds-password-1"
  kms_key_id = aws_kms_key.kms.arn
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = random_password.rds.result
}
