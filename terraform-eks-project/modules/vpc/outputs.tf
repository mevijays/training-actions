resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count
  vpc_id = aws_vpc.this.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value = var.create_new_vpc ? aws_vpc.this[0].id : var.existing_vpc_id
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value = var.create_new_vpc ? [aws_subnet.public[0].id] : var.existing_subnet_ids
}