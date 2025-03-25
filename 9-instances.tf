//dynamically search for instance ami id, you may need to change values in for name filter as per your prefered image type
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] #id of the ami provider (canonical)

}

// Get list of available AZs in the region
data "aws_availability_zones" "available" {}

//instance configuration
resource "aws_instance" "webserver" {
  for_each   = var.private_subnet_cidrs
  depends_on = [aws_security_group.sg_private]

  ami = data.aws_ami.ubuntu.image_id

  instance_type = var.instance_type_value

  security_groups = [aws_security_group.sg_private.id]

  subnet_id = aws_subnet.private-subnet[each.key].id

  monitoring = true

  # availability_zone = var.private_subnet_cidrs["subnet-az${each.value["idx"]}"].az
  availability_zone = aws_subnet.private-subnet[each.key].availability_zone

  user_data = templatefile("./scripts/run-httpd.sh", { APACHE_LOG_DIR = "/var/log/httpd" })
  # key_name  = "lol"
  key_name = "efs_ec2_key_pair"

  tags = {
    name = "${var.basename}-webserver-${each.value["az"]}"
  }
}

//import the key to make it default kms key for encryption
resource "aws_ebs_default_kms_key" "webserver" {
  key_arn    = aws_kms_key.kms.arn
  depends_on = [aws_kms_key.kms]
}

// enable encryption for root devices as well
resource "aws_ebs_encryption_by_default" "webserver" {
  depends_on = [aws_ebs_default_kms_key.webserver]
}

# resource "aws_instance" "webserver_pub" {
#   depends_on = [ aws_security_group.sg_loadbalancer ]
#   ami = data.aws_ami.ubuntu.image_id
#   instance_type = var.instance_type_value
#   security_groups = [ aws_security_group.sg_loadbalancer.id ]
#   subnet_id = aws_subnet.public.1.id
#   monitoring = true
#   availability_zone = var.availability_zones.1
#   user_data = templatefile("./scripts/run-httpd.sh", {APACHE_LOG_DIR = "/var/log/httpd"})
#   key_name = "lol"
#   associate_public_ip_address = true
#   tags = {
#     name = "Webserver_public"
#   }
# }
# //import the key to make it default kms key for encryption
# resource "aws_ebs_default_kms_key" "webserver_pub" {
#   key_arn = aws_kms_key.kms.arn
#   depends_on = [ aws_kms_key.kms ]
# }
# // enable encryption for root devices as well
# resource "aws_ebs_encryption_by_default" "webserver_pub" {
#   depends_on = [ aws_ebs_default_kms_key.webserver_pub ]
# }