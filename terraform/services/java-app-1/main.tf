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

# --------------------------------------
# VPC creation
# --------------------------------------
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

# --------------------------------------
# Tagging Data Subnets
# --------------------------------------
resource "aws_ec2_tag" "data_subnet_name_tag" {
  count       = length(var.data_subnets)
  resource_id = module.vpc.private_subnets[count.index + length(var.private_subnets)]
  key         = "Name"
  value       = "${var.name}-data-subnet-${element(var.availability_zones, count.index)}"
}

# --------------------------------------
# Fetch VPC and Subnets
# --------------------------------------
data "aws_vpc" "runner_vpc" {
  cidr_block = var.vpc_cidr
}

data "aws_subnets" "private_subnet_ids" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.runner_vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

# --------------------------------------
# Runner Stack (No token fetched here!)
# --------------------------------------
module "runner_stack" {
  source                     = "../../templates/workload/compute/runner_stack"

  vpc_id                     = data.aws_vpc.runner_vpc.id
  private_subnet_ids          = [for subnet in data.aws_subnets.private_subnet_ids.ids : subnet]
  
  key_name                   = var.key_name
  github_repo                = var.github_repo
  secret_name                = var.secret_name
  region                     = var.region
  ami_id                     = var.ami_id
  runner_version             = var.runner_version
  instance_type              = var.instance_type
  iam_instance_profile_name  = var.iam_instance_profile_name
  name_prefix                = var.application # typically java-app-1
}
