variable "create_new_vpc" {
  description = "Set to true to create a new VPC, or false to use the existing default VPC."
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for the new VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for the VPC."
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}