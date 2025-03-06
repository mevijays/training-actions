resource "aws_vpc" "this" {
  count = var.create_new_vpc ? 1 : 0

  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "public" {
  count = var.create_new_vpc ? 1 : 0

  vpc_id            = aws_vpc.this[0].id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.project_name}-subnet"
    "kubernetes.io/cluster/${var.project_name}" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_vpc" "existing" {
  count = var.create_new_vpc ? 0 : 1

  id = var.existing_vpc_id
}

resource "aws_internet_gateway" "this" {
  count = var.create_new_vpc ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public" {
  count = var.create_new_vpc ? 1 : 0

  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = var.create_new_vpc ? 1 : 0

  subnet_id      = aws_subnet.public[0].id
  route_table_id = aws_route_table.public[0].id
}

output "vpc_id" {
  value = var.create_new_vpc ? aws_vpc.this[0].id : aws_vpc.existing[0].id
}

output "public_subnet_id" {
  value = var.create_new_vpc ? aws_subnet.public[0].id : null
}