variable "name" {
  description = "Name of the VPC and associated resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use for the subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs corresponding to availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs corresponding to availability zones"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to enable a NAT Gateway for private subnet internet access"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment tag (e.g., dev, qa, prod)"
  type        = string
}
