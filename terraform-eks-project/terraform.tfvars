region                         = "us-east-1"
vpc_id                         = "vpc-0123456789abcdef0"
private_subnet_names           = ["private-subnet-a", "private-subnet-b"]
public_subnet_names            = ["public-subnet-a", "public-subnet-b"]
cluster_name                   = "my-eks-cluster"
cluster_version                = "1.28"
cluster_endpoint_public_access = true
node_group_name                = "default-node-group"
instance_types                 = ["t3.medium"]
min_size                       = 2
max_size                       = 4
desired_size                   = 2
use_existing_vpc               = false