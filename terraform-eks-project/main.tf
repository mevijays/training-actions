provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  create_new_vpc = var.create_new_vpc
  vpc_cidr = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
  availability_zone = var.availability_zone
  project_name = var.project_name
  existing_vpc_id = var.existing_vpc_id
  existing_subnet_ids = var.existing_subnet_ids
}

module "eks" {
  source = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.subnet_ids
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