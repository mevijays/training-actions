variable "create_new_vpc" {
  description = "Whether to create a new VPC or use an existing one"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
  default     = "us-west-2a"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "existing_vpc_id" {
  description = "ID of an existing VPC to use"
  type        = string
  default     = ""
}

variable "existing_subnet_ids" {
  description = "IDs of existing subnets to use"
  type        = list(string)
  default     = []
}