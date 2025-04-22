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

variable "application" {
  description = "Application name and/or identifier"
  type        = string
  default     = null # can be left blank/out due to shared resources not tied to an application
}

variable "created_by" {
  description = "The framework, tool, and/or method that created this resource - terraform, serverless, pulumi, manual, etc."
  type        = string
  default     = "terraform"

  validation {
    condition     = can(regex("^terraform$", var.created_by))
    error_message = "The created_by value should be 'terraform' since this is written in terraform."
  }
}

#variable "environment" {
#  description = "The environment does this resource belong to? - dev, qa, prod"
#  type        = string
#
#  validation {
#    condition     = can(regex("(^Dev$)|(^Qa$)|(^prod$)", var.environment))
#    error_message = "The environment value should be one of - sandbox, nonprod, prod."
#  }
#}

variable "repository" {
  description = "The repository name where this resource is managed and codified"
  type        = string

  validation {
    condition     = can(regex("^https:\\/\\/github\\.com\\/*", var.repository))
    error_message = "The repository should be in the form of `https://github.com/*`."
  }
}
