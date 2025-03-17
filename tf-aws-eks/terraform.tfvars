aws_region = "us-east-1"
aws_account_id = "192.168.0.0/16"
vpc_name       = "eks-dev"
vpc_cidr       = "192.168.0.0/16"
public_subnets = [ "192.168.0.0/20", "192.168.16.0/20", "192.168.32.0/20" ]
private_subnets = [ "192.168.48.0/20", "192.168.64.0/20", "192.168.80.0/20" ]
instance_type  = "t3.medium"
tags = {
    Environment = "dev"
    Terraform   = "true"
  }
is_spot = true
cluster_version = "1.31"
eks_name = "eks-dev"
eks_admin_arns = [
    "arn:aws:iam::430118834478:user/eks16",
    "arn:aws:iam::430118834478:user/eks17",
    "arn:aws:iam::430118834478:role/gh-actions-role"
  ]