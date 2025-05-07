name               = "runner-dev-vpc"
vpc_cidr           = "10.220.36.0/24"
availability_zones = ["us-west-2a", "us-west-2b"]

public_subnets     = ["10.220.36.128/26", "10.220.36.192/26"]
private_subnets    = ["10.220.36.0/26", "10.220.36.64/26"]


enable_nat_gateway = true
enable_ipv6        = false

environment        = "dev"
application        = "runner-app"
created_by         = "terraform"
repository         = "podilithanoj/platform"

igw_tags = {
  Name = "runner-dev-vpc-igw"
}
nat_gateway_tags = {
  Name = "runner-dev-vpc-natgw"
  Tier = "network"
}
