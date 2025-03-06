# Terraform EKS Project

This project provisions an Amazon EKS (Elastic Kubernetes Service) cluster using Terraform. It includes options to either use an existing default VPC or create a new VPC with public subnets. Additionally, it sets up an Amazon ECR (Elastic Container Registry) for storing container images.

## Project Structure

The project is organized into the following files:

- **main.tf**: Entry point for the Terraform configuration, handling the provisioning logic for the EKS cluster and VPC.
- **variables.tf**: Defines input variables for the configuration, including options for VPC usage and EKS parameters.
- **outputs.tf**: Specifies outputs such as the EKS cluster endpoint and VPC ID.
- **providers.tf**: Configures the required providers, primarily AWS.
- **vpc.tf**: Contains logic for creating a new VPC and public subnets if needed.
- **eks.tf**: Provisions the EKS cluster and associated resources.
- **ecr.tf**: Creates the ECR repository for the EKS cluster.

### Modules

The project uses modules for better organization:

- **modules/vpc**: Contains resources for VPC and subnet creation.
- **modules/eks**: Contains resources for EKS cluster and node group provisioning.
- **modules/ecr**: Contains resources for ECR repository creation.

## Prerequisites

- Terraform installed on your local machine.
- AWS account with appropriate permissions to create EKS, VPC, and ECR resources.
- AWS CLI configured with your credentials.

## Setup Instructions

1. Clone the repository:
   ```
   git clone <repository-url>
   cd terraform-eks-project
   ```

2. Update the `terraform.tfvars` file with your desired configuration values.

3. Initialize the Terraform project:
   ```
   terraform init
   ```

4. Validate the configuration:
   ```
   terraform validate
   ```

5. Plan the deployment:
   ```
   terraform plan
   ```

6. Apply the configuration to provision the resources:
   ```
   terraform apply
   ```

7. Once the deployment is complete, you can access the EKS cluster using the provided outputs.

## Outputs

After the successful execution of the Terraform scripts, the following outputs will be available:

- EKS Cluster Name
- EKS Cluster Endpoint
- VPC ID
- ECR Repository URI

## Cleanup

To remove all resources created by this project, run:
```
terraform destroy
```

This will delete all the resources provisioned by Terraform.