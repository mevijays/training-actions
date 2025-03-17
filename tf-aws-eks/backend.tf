terraform {
  backend "s3" {
    bucket = "tcslabsfjbs"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}