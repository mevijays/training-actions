provider "aws" {
  region = var.region
}

resource "aws_vpc" "eks_vpc" {
  count = var.create_new_vpc ? 1 : 0

  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "eks_subnet" {
  count = var.create_new_vpc ? 1 : 0

  vpc_id            = aws_vpc.eks_vpc[0].id
  cidr_block        = var.subnet_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-subnet"
  }
}

module "vpc" {
  source = "./modules/vpc"
  create_new_vpc = var.create_new_vpc
  vpc_cidr = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
  availability_zone = var.availability_zone
  project_name = var.project_name
}

module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id = var.create_new_vpc ? aws_vpc.eks_vpc[0].id : var.existing_vpc_id
  subnet_ids = var.create_new_vpc ? [aws_subnet.eks_subnet[0].id] : var.existing_subnet_ids
  node_instance_type = var.node_instance_type
  desired_capacity = var.desired_capacity
  max_size = var.max_size
  min_size = var.min_size
  project_name = var.project_name
}

module "ecr" {
  source = "./modules/ecr"
  project_name = var.project_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}