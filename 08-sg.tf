// Security group for Load Balancer in public subnet
resource "aws_security_group" "sg_loadbalancer" {
  name        = "LoadBalancer"
  description = "Security Group for public Load Balancer"
  vpc_id      = aws_vpc.main.id
  tags = {
    name = "loadbalancer"
  }
}

resource "aws_security_group_rule" "http_lb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks       = [aws_vpc.main.cidr_block, "0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks       = [aws_vpc.main.cidr_block, "0.0.0.0/0"]
}

resource "aws_security_group_rule" "https_lb" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks       = [aws_vpc.main.cidr_block, "0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks       = [aws_vpc.main.cidr_block, "0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh_lb" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks       = [aws_vpc.main.cidr_block, "0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_ssh" {
  type              = "egress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks       = [aws_vpc.main.cidr_block, "0.0.0.0/0"]
}

// Security group for RDS instance (initially empty, rules defined separately)
resource "aws_security_group" "sg_rds" {
  name        = "sg_rds"
  description = "Security group for private RDS instance"
  vpc_id      = aws_vpc.main.id
}

// Security group for private instances
resource "aws_security_group" "sg_private" {
  name        = "sg_private"
  description = "Security group for private instances"
  vpc_id      = aws_vpc.main.id
}

// Allow private instances to access RDS (breaking the cycle)
resource "aws_security_group_rule" "sg_private_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_rds.id
  source_security_group_id = aws_security_group.sg_private.id
}

// Allow RDS to respond to private instances (if necessary)
resource "aws_security_group_rule" "sg_rds_to_private" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_rds.id
  source_security_group_id = aws_security_group.sg_private.id
}

// Allow traffic from Load Balancer to private instances
resource "aws_security_group_rule" "lb_to_private_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_private.id
  # source_security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "private_http_to_lb" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_private.id
  # source_security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_to_private_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_private.id
  # source_security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "private_https_to_lb" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.sg_private.id
  # source_security_group_id = aws_security_group.sg_loadbalancer.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_to_private_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_private.id
  source_security_group_id = aws_security_group.sg_loadbalancer.id
}

resource "aws_security_group_rule" "private_ssh_to_lb" {
  type                     = "egress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_private.id
  source_security_group_id = aws_security_group.sg_loadbalancer.id
}

// Allow private instances to communicate with Load Balancer
# resource "aws_security_group_rule" "private_to_lb" {
#   type                     = "egress"
#   from_port                = 0
#   to_port                  = 0
#   protocol                 = "-1"
#   security_group_id        = aws_security_group.sg_private.id
#   source_security_group_id = aws_security_group.sg_loadbalancer.id
# }
