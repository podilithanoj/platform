variable "application" {
  description = "Application or microservice name"
  type        = string
}

variable "created_by" {
  description = "Indicates the tool/team that created the infrastructure"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "repository" {
  description = "Source code repository name (e.g., org/repo)"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name for EC2 instance"
  type        = string
}

variable "github_repo" {
  description = "GitHub repo for registering the runner (e.g., org/repo)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the runner"
  type        = string
}

variable "runner_version" {
  description = "GitHub runner version (e.g., 2.323.0)"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name for the runner EC2"
  type        = string
}

variable "region" {
  description = "AWS region for deployment"
  type        = string
}

variable "secret_name" {
  description = "Name of the AWS Secrets Manager secret holding the GitHub token"
  type        = string
}

variable "runner_label" {
  type        = string
  description = "GitHub runner label used during registration"
}

variable "asg_config" {
  description = "Auto Scaling Group configuration"
  type = object({
    desired_capacity          = number
    max_size                  = number
    min_size                  = number
    health_check_type         = string
    health_check_grace_period = number
    instance_refresh = optional(object({
      strategy = string
      preferences = object({
        min_healthy_percentage = number
        instance_warmup        = number
        checkpoint_delay       = number
        checkpoint_percentages = list(number)
      })
    }))
  })
}
