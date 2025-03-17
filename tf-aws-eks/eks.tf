# Ref - https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.eks_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  
  # Add EBS CSI driver addon
  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      configuration_values = jsonencode({
        controller = {
          extraVolumeTags = var.tags
        }
      })
    }
  }

  # Access entries using for expression to create entries from list of ARNs
  access_entries = {
    for arn in var.eks_admin_arns :
      # Extract the last part of the ARN as the key (username or role name)
      element(split("/", arn), length(split("/", arn)) - 1) => {
        principal_arn = arn
        
        policy_associations = {
          admin = {
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
            access_scope = {
              type = "cluster"
            }
          }
        }
      }
  }

  # Existing node group configuration
  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = [ var.instance_type ]
      capacity_type  = var.is_spot? "SPOT" : "ON_DEMAND"
    }
  }

  tags = var.tags
}