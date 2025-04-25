variable "ami_id" {
  description = "ami id for the instance"
  type        = string
}
variable "instance_type" {
  description = "instance type for the creation"
  type        = string
}
variable "key_name" {
  description = "pem key file name"
  type        = string
}

variable "github_repo" {
  description = "github repo configuration"
  type        = string
}

variable "github_token" {
  description = "token for github authentication"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "runner_version" {
  description = "Version of the GitHub Runner to install"
  type        = string
}
