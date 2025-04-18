module "vpc" {
  source               = "../../modules/network/vpc"
  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnets       = var.public_subnets
  private_subnets      = var.private_subnets
  enable_nat_gateway   = var.enable_nat_gateway
  environment          = var.environment
}

module "ec2" {
  source             = "../../modules/workload/compute/ec2"
  ami                = var.ami
  instance_type      = var.instance_type
  subnet_id          = var.subnet_id
  security_group_ids = var.security_group_ids
  key_name           = var.key_name
  name               = var.ec2_name
  environment        = var.environment
}