variable "aws_region" {
    description = "The region where the infrastructure should be deployed to"
    type = string
    default = "us-east-1"
}

variable "aws_account_id" {
    description = "AWS Account ID"
    type = string
    default = "430118834478"
}

variable "vpc_name" {
  description = "VPC Name for Jenkins Server VPC"
  type        = string
  default = "eks-vpc"
}

variable "vpc_cidr" {
  description = "VPC CIDR for Jenkins Server VPC"
  type        = string
  default = "192.168.0.0/16"
}

variable "public_subnets" {
  description = "Subnets CIDR range"
  type        = list(string)
  default = [ "192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20" ]
}

variable "private_subnets" {
  description = "Subnets CIDR range"
  type        = list(string)
  default = [ "192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20" ]
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default = "t3.medium"
}
variable "eks_name" {
  description = "eks cluster name"
  default = "eks-dev"
  type = string
}
variable "cluster_version" {
  description = "eks cluster version"
  default = "1.31"
  type = string
}
variable "is_spot" {
  type = bool
  default = true
  description = "If nodepool should be spot instances"
}
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Terraform   = "true"
  }
}

variable "eks_admin_arns" {
  description = "List of IAM user/role ARNs that will have admin access to the EKS cluster"
  type        = list(string)
  default     = [
    "arn:aws:iam::430118834478:user/eks16",
    "arn:aws:iam::430118834478:user/eks17",
    "arn:aws:iam::430118834478:role/gh-actions"
  ]
}