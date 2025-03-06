output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value = module.eks.cluster_endpoint
}

output "vpc_id" {
  description = "ID of the VPC"
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value = module.ecr.repository_url
}

output "cluster_name" {
  description = "Name of the EKS cluster"
  value = module.eks.cluster_name
}

output "subnet_ids" {
  description = "IDs of the subnets used for the EKS cluster"
  value = module.vpc.subnet_ids
}