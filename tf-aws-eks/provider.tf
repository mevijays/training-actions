terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.25.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.36.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = module.eks.cluster_name
}