variable "create_new_vpc" {
  description = "Set to true to create a new VPC, false to use the existing default VPC"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for the new VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "eks_node_instance_type" {
  description = "EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "eks_node_group_desired_capacity" {
  description = "Desired number of worker nodes in the EKS node group"
  type        = number
  default     = 2
}

variable "eks_node_group_max_size" {
  description = "Maximum number of worker nodes in the EKS node group"
  type        = number
  default     = 3
}

variable "eks_node_group_min_size" {
  description = "Minimum number of worker nodes in the EKS node group"
  type        = number
  default     = 1
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "my-ecr-repo"
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-west-2"
}