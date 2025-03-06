resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  lifecycle_policy {
    rule {
      rule_priority = 1
      description   = "Expire untagged images"
      selection {
        tag_status = "untagged"
        count_type = "since-image-pushed"
        count_unit = "days"
        count_number = var.expiration_days
      }
      action {
        type = "expire"
      }
    }
  }
}

output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.this.name
}