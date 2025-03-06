variable "create_new_vpc" {
  description = "Set to true to create a new VPC, or false to use the existing default VPC."
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for the new VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

variable "eks_node_group_name" {
  description = "The name of the EKS node group."
  type        = string
  default     = "my-node-group"
}

variable "desired_capacity" {
  description = "The desired number of nodes in the EKS node group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of nodes in the EKS node group."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "The minimum number of nodes in the EKS node group."
  type        = number
  default     = 1
}

variable "region" {
  description = "The AWS region to deploy the resources."
  type        = string
  default     = "us-west-2"
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository."
  type        = string
  default     = "my-ecr-repo"
}