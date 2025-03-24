resource "aws_db_subnet_group" "rds" {
  name = "rds-subnet-group"
  subnet_ids = [ for s in aws_subnet.private-subnet-rds : s.id ]

  tags ={
    Name = "${var.basename}-rds-subnet-group"
  }
}

resource "aws_db_instance" "rds" {
  identifier = "ecomdb"
  allocated_storage = 5
  max_allocated_storage = 10
  db_name = "ecomdb"
  engine = "mysql"
  instance_class = var.rds_instance_type
  username = "admin"
  password = random_password.rds.result
  storage_encrypted = true
  storage_type = "gp2"
#   iops = 1000
  kms_key_id = aws_kms_key.kms.arn
  db_subnet_group_name = aws_db_subnet_group.rds.name
  multi_az = false
  apply_immediately = true
  skip_final_snapshot = true
  vpc_security_group_ids = [ aws_security_group.sg_rds.id ]

depends_on = [ aws_security_group.sg_rds ]
}

# resource "aws_rds_certificate" "rds-certificate" {
#   certificate_identifier = aws_acm_certificate.cert.id
# }