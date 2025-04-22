module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = var.name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = true
  one_nat_gateway_per_az = false

  tags = {
    Environment = var.environment
    Project     = "JavaApp"
  }
}


data "aws_caller_identity" "current" {}

locals {
  tags = {
    Application = var.application
    CreatedBy   = var.created_by
    DeployedBy  = data.aws_caller_identity.current.arn
    #Environment = var.environment
    Repository  = var.repository
  }
}