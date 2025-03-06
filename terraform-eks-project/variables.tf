variable "create_new_vpc" {
  description = "Whether to create a new VPC or use an existing one"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "us-west-2a"
}

variable "existing_vpc_id" {
  description = "ID of an existing VPC to use"
  type        = string
  default     = ""
}

variable "existing_subnet_ids" {
  description = "IDs of existing subnets to use"
  type        = list(string)
  default     = []
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-cluster"
}

variable "eks_node_group_name" {
  description = "The name of the EKS node group."
  type        = string
  default     = "my-node-group"
}

variable "node_instance_type" {
  description = "Instance type for the EKS node group"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired capacity for the EKS node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum size for the EKS node group"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum size for the EKS node group"
  type        = number
  default     = 1
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository."
  type        = string
  default     = "my-ecr-repo"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "eks-project"
}