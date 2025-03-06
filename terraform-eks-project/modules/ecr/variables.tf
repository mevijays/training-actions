variable "ecr_repository_name" {
  description = "The name of the ECR repository to create."
  type        = string
}

variable "ecr_image_tag_mutability" {
  description = "Specifies whether image tags can be mutated. Valid values are 'MUTABLE' or 'IMMUTABLE'."
  type        = string
  default     = "IMMUTABLE"
}

variable "ecr_lifecycle_policy" {
  description = "The lifecycle policy for the ECR repository."
  type        = string
  default     = jsonencode({
    rules = [
      {
        rulePriority = 1
        selection    = {
          tagStatus = "tagged"
          tagPrefixList = ["prod"]
        }
        action = {
          type = "expire"
        }
        expiration = {
          days = 30
        }
      }
    ]
  })
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}