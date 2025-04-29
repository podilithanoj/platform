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
  description = "List of data-tier subnet CIDRs"
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
  description = "Source code repository name (example: org/repo)"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair (PEM file) for EC2 instances"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository for registering the runner (format: org/repo)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for launching EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for GitHub runner EC2 instance"
  type        = string
}

variable "runner_version" {
  description = "Version of the GitHub Runner to install (example: 2.308.0)"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name attached to GitHub runner EC2 instances"
  type        = string
}

variable "region" {
  description = "AWS region where resources will be deployed"
  type        = string
}

variable "secret_name" {
  description = "AWS Secrets Manager secret name containing GitHub runner registration token"
  type        = string
}
