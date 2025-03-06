terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0"
    }
  }
  backend "s3" {
    bucket = "kr-tfstate-bucket"  # Replace with your bucket name
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

# Data sources for existing VPC
data "aws_vpc" "existing" {
  count = var.use_existing_vpc ? 1 : 0
  id    = var.vpc_id
}

data "aws_subnets" "private" {
  count = var.use_existing_vpc ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = var.private_subnet_names
  }
}

data "aws_subnets" "public" {
  count = var.use_existing_vpc ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:Name"
    values = var.public_subnet_names
  }
}

locals {
  # Safely access data sources
  private_subnet_ids = (var.use_existing_vpc && 
                        length(data.aws_subnets.private) > 0) ? 
                        toset(data.aws_subnets.private[0].ids) : 
                        toset([])
                        
  public_subnet_ids = (var.use_existing_vpc && 
                       length(data.aws_subnets.public) > 0) ? 
                       toset(data.aws_subnets.public[0].ids) : 
                       toset([])
}

# Add required Kubernetes tags to existing subnets if using existing VPC
resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  for_each    = local.private_subnet_ids
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "private_subnet_elb_tag" {
  for_each    = local.private_subnet_ids
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "public_subnet_cluster_tag" {
  for_each    = local.public_subnet_ids
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "public_subnet_elb_tag" {
  for_each    = local.public_subnet_ids
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

# Create a new VPC if not using existing VPC
module "vpc" {
  count   = var.use_existing_vpc ? 0 : 1
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Safely determine what VPC ID to use
  vpc_id = var.use_existing_vpc ? var.vpc_id : module.vpc[0].vpc_id
  
  # Safely determine what subnet IDs to use
  subnet_ids = var.use_existing_vpc ? (
    length(local.private_subnet_ids) > 0 ? local.private_subnet_ids : []
  ) : module.vpc[0].private_subnets

  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    default = {
      name = var.node_group_name

      instance_types = var.instance_types

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
    }
  }
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}
