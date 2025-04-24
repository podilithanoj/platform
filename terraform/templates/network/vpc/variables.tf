variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of Availability Zones used"
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
  description = "List of data-tier (private) subnet CIDRs"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Enable IPv6 support"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "created_by" {
  description = "Indicates the tool/team that created the infrastructure"
  type        = string
  default     = "terraform"
}

variable "application" {
  description = "Application or microservice name"
  type        = string
}

variable "repository" {
  description = "URL of the Git repository managing this infrastructure"
  type        = string
}

variable "vpc_tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Tags to apply to all public subnets"
  type        = map(string)
  default     = {}
}
