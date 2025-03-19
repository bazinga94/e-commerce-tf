resource "aws_eip" "nat" {
  for_each = var.public_subnet_cidrs
  domain   = "vpc"

  tags = {
    Name = "${var.basename}-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "ngw" {
  for_each      = var.public_subnet_cidrs
  subnet_id     = aws_subnet.public-subnet[each.key].id
  allocation_id = aws_eip.nat[each.key].id

  tags = {
    Name = "${var.basename}-ngw-${each.key}"
  }
}

# resource "aws_nat_gateway" "ngw-rds" {
#     for_each = var.private_subnet_cidrs_rds
#     subnet_id = aws_subnet.private_subnet_cidrs_rds[each.key].id
#     allocation_id = aws_eip.nat[each.key].id

#     tags = {
#     Name = "${var.basename}-ngw-${each.key}"
#   }
# }