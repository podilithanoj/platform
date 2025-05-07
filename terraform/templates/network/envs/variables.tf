variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use"
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

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Enable IPv6 support in VPC"
  type        = bool
  default     = false
}

variable "vpc_tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Tags to apply to public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Tags to apply to private subnets"
  type        = map(string)
  default     = {}
}

variable "igw_tags" {
  description = "Tags to apply to the Internet Gateway"
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags" {
  description = "Tags to apply to NAT Gateways"
  type        = map(string)
  default     = {}
}
variable "application" {
  description = "Application name"
  type        = string
}

variable "created_by" {
  description = "Creator of the infrastructure"
  type        = string
  default     = "terraform"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "repository" {
  description = "Git repository URL or name"
  type        = string
}

