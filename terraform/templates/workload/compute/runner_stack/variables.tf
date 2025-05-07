variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for deployment"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for deployment"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs (optional)"
  type        = list(string)
  default     = []
}

variable "name_prefix" {
  description = "Prefix for all runner resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the GitHub runner EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the GitHub runner"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the EC2 key pair for SSH access"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository for runner registration"
  type        = string
}

variable "runner_version" {
  description = "Version of the GitHub Actions runner to install"
  type        = string
  default     = "2.311.0"
}

variable "runner_label" {
  description = "GitHub runner label for registration"
  type        = string
  default     = "self-hosted"
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name for the runner EC2 instance"
  type        = string
}

variable "secret_name" {
  description = "AWS Secrets Manager secret name for the GitHub registration token"
  type        = string
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
  default = {
    desired_capacity          = 2
    max_size                  = 2
    min_size                  = 2
    health_check_type         = "EC2"
    health_check_grace_period = 300
  }
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
} 