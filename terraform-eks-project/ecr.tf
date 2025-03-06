resource "aws_ecr_repository" "eks_repository" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"
  lifecycle_policy {
    rule {
      rule_priority = 1
      description   = "Expire untagged images older than 30 days"
      selection {
        tag_status = "UNTAGGED"
        count_type = "since-image-pushed"
        count_unit = "days"
        count_number = 30
      }
      action {
        type = "expire"
      }
    }
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.eks_repository.repository_url
}