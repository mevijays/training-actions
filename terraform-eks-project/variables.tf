variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "my-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster"
  type        = string
  default     = "1.28"
}

variable "use_existing_vpc" {
  description = "Whether to use an existing VPC"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of the existing VPC (only needed if use_existing_vpc = true)"
  type        = string
  default     = ""
}

variable "private_subnet_names" {
  description = "Names of private subnets in the existing VPC (only needed if use_existing_vpc = true)"
  type        = list(string)
  default     = []
}

variable "public_subnet_names" {
  description = "Names of public subnets in the existing VPC (only needed if use_existing_vpc = true)"
  type        = list(string)
  default     = []
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
  default     = "default-node-group"
}

variable "instance_types" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 4
}

variable "desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "cluster_endpoint_public_access" {
  description = "Whether the EKS cluster endpoint is publicly accessible"
  type        = bool
  default     = true
}