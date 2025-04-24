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

terraform {
  backend "s3" {}
}

module "vpc" {
  source = "../../templates/network/vpc"

  name               = var.name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  data_subnets       = var.data_subnets
  enable_nat_gateway = var.enable_nat_gateway
  enable_ipv6        = var.enable_ipv6
  environment        = var.environment
  created_by         = var.created_by
  application        = var.application
  repository         = var.repository

  vpc_tags = local.tags

  public_subnet_tags = merge(local.tags, {
    Tier = "public"
    Name = "${var.name}-${var.environment}-public-subnet"
  })

  private_subnet_tags = merge(local.tags, {
    Tier = "private"
    Name = "${var.name}-${var.environment}-private-subnet"
  })
}


