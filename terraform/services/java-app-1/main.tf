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
  enable_nat_gateway = var.enable_nat_gateway
  environment        = var.environment
  repository         = var.repository
}



