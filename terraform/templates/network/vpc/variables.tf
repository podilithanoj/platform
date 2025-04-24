variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of AZs used in this environment"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}
variable "data_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Whether to enable NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Whether to enable IPv6 addressing"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (e.g., dev, qa, prod)"
  type        = string
}

variable "created_by" {
  description = "Indicates who created the infrastructure"
  type        = string
  default     = "terraform"
}

variable "application" {
  description = "Application name or identifier"
  type        = string
}

variable "repository" {
  description = "Repository URL managing this code"
  type        = string
}

variable "vpc_tags" {
  description = "Tags applied to VPC resources"
  type        = map(string)
}

variable "public_subnet_tags" {
  description = "Tags applied to all public subnets"
  type        = map(string)
}

variable "private_subnet_tags" {
  description = "Tags applied to all private subnets"
  type        = map(string)
}

