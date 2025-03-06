resource "aws_vpc" "eks_vpc" {
  count = var.create_new_vpc ? 1 : 0

  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_subnet" "eks_public_subnet" {
  count = var.create_new_vpc ? 1 : 0

  vpc_id            = aws_vpc.eks_vpc[0].id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "eks-public-subnet"
  }
}

resource "aws_vpc" "default_vpc" {
  count = var.create_new_vpc ? 0 : 1

  id = data.aws_vpc.default.id
}

data "aws_vpc" "default" {
  default = true
}