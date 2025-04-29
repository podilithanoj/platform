variable "ami_id" {
  description = "AMI ID for the GitHub runner EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the GitHub runner (e.g., t3.medium)"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair for SSH access"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository for which this runner will be registered (format: org/repo)"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs where runners will be deployed"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the runners will be deployed"
  type        = string
}

variable "runner_version" {
  description = "Version of the GitHub Actions runner to install (e.g., 2.308.0)"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile to assign to the runner EC2 instance"
  type        = string
}

variable "secret_name" {
  description = "AWS Secrets Manager secret name containing the GitHub registration token"
  type        = string
}

variable "region" {
  description = "AWS region where the infrastructure is deployed"
  type        = string
}

variable "name_prefix" {
  description = "Prefix to be added to all runner resources (for easy identification)"
  type        = string
}
