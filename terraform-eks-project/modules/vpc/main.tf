resource "aws_vpc" "this" {
  count = var.create_new_vpc ? 1 : 0

  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  count = var.create_new_vpc ? 1 : 0

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

resource "aws_vpc" "existing" {
  count = var.create_new_vpc ? 0 : 1

  id = var.existing_vpc_id
}

output "vpc_id" {
  value = var.create_new_vpc ? aws_vpc.this[0].id : aws_vpc.existing[0].id
}

output "public_subnet_id" {
  value = var.create_new_vpc ? aws_subnet.public[0].id : null
}