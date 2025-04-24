variable "name" {
  description = "Name prefix for VPC and subnets"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones"
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
  description = "Whether to create NAT Gateway(s)"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Enable IPv6 for subnets"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "created_by" {
  description = "Indicates the tool or team that created this infrastructure"
  type        = string
  default     = "terraform"
}

variable "application" {
  description = "Application or microservice name"
  type        = string
}

variable "repository" {
  description = "Source code repository URL"
  type        = string
}
