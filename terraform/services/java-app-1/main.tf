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
    Name = "${var.name}-${var.environment}-public-subnet"
  })
}

# Tags only the data-specific subnets (which were appended to private_subnets)
resource "aws_ec2_tag" "data_subnet_name_tag" {
  count       = length(var.data_subnets)
  resource_id = module.vpc.private_subnets[count.index + length(var.private_subnets)]
  key         = "Name"
  value       = "${var.name}-${var.environment}-data-subnet-${element(var.availability_zones, count.index)}"
}
