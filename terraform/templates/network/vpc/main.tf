module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name            = var.name
  cidr            = var.vpc_cidr
  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  public_dedicated_network_acl  = false
  private_dedicated_network_acl = false

  enable_ipv6                                    = var.enable_ipv6
  public_subnet_assign_ipv6_address_on_creation  = var.enable_ipv6
  private_subnet_assign_ipv6_address_on_creation = false
  public_subnet_ipv6_prefixes                    = var.enable_ipv6 ? [0, 1, 2] : []
  private_subnet_ipv6_prefixes                   = var.enable_ipv6 ? [3, 4, 5] : []

  vpc_tags            = var.vpc_tags
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags

  map_public_ip_on_launch = false
}
