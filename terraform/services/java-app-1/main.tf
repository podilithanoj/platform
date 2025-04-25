terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" {}

locals {
  tags = {
    Application = var.application
    CreatedBy   = var.created_by
    DeployedBy  = data.aws_caller_identity.current.arn
    Environment = var.environment
    Repository  = var.repository
  }
}

module "vpc" {
  source  = "../../templates/network/vpc"

  name               = var.name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = concat(var.private_subnets, var.data_subnets)
  enable_nat_gateway = var.enable_nat_gateway
  enable_ipv6        = var.enable_ipv6

  environment  = var.environment
  created_by   = var.created_by
  application  = var.application
  repository   = var.repository

  vpc_tags = local.tags

  public_subnet_tags = merge(local.tags, {
    Tier = "public"
    Name = "${var.name}-public-subnet"
  })
}

# Tags only the data-specific subnets (which were appended to private_subnets)
resource "aws_ec2_tag" "data_subnet_name_tag" {
  count       = length(var.data_subnets)
  resource_id = module.vpc.private_subnets[count.index + length(var.private_subnets)]
  key         = "Name"
  value       = "${var.name}-data-subnet-${element(var.availability_zones, count.index)}"
}

# Fetch the GitHub token from AWS Secrets Manager
data "aws_secretsmanager_secret" "github_token" {
  name = "github-token"  # The ID of your secret
}

data "aws_secretsmanager_secret_version" "github_token_version" {
  secret_id = data.aws_secretsmanager_secret.github_token.id
}

# Directly assign the secret value if it's plain text
locals {
  github_token = data.aws_secretsmanager_secret_version.github_token_version.secret_string
}

module "runner_stack" {
  source             = "../../templates/workload/compute/runner_stack"
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
  key_name           = var.key_name
  github_token       = local.github_token
  github_repo        = var.github_repo
  ami_id             = var.ami_id
  runner_version     = var.runner_version
  instance_type      = var.instance_type
}

