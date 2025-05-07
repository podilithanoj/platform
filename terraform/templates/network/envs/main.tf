terraform {
  required_version = ">= 1.4.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97.0"
    }
  }
  backend "s3" {
    bucket         = "glacade"
    key            = "network/dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "../vpc"

  name               = var.name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_ipv6        = var.enable_ipv6

  environment = var.environment
  created_by  = var.created_by
  application = var.application
  repository  = var.repository

  tags = local.tags

  vpc_tags = merge(local.tags, {
    Name = "${var.name}-vpc"
  })

  public_subnet_tags = merge(local.tags, {
    Name = "${var.name}-public-subnet"
    Tier = "public"
  })

  private_subnet_tags = merge(local.tags, {
    Name = "${var.name}-private-subnet"
    Tier = "private"
  })

  igw_tags = merge(local.tags, {
    Name = "${var.name}-igw"
  })

  nat_gateway_tags = merge(local.tags, {
    Name = "${var.name}-natgw"
    EIP  = "${var.name}-eip"
  })
}
