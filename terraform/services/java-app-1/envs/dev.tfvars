name               = "runner-dev-vpc"
vpc_cidr           = "10.220.12.0/22"
availability_zones = ["us-east-1a", "us-east-1b"]

public_subnets  = ["10.220.15.0/26", "10.220.15.64/26"]
private_subnets = ["10.220.12.0/24", "10.220.13.0/24"]
data_subnets    = ["10.220.14.0/25", "10.220.14.128/25"]
private_subnet_ids = ["subnet-09b736fdc8c995fce", "subnet-02ef34eb78377cd56"]
vpc_id          = "vpc-04864e75199aeb0ef"

enable_nat_gateway = true
enable_ipv6        = false

environment = "dev"
application = "runner-app"
created_by  = "terraform"

repository = "https://github.com/podilithanoj/platform/tree/main/terraform"
key_name   = "runner"
github_repo = "https://github.com/podilithanoj/platform.git"
####github_token = "add you token here"######
ami_id       = "ami-0d59d17fb3b322d0b"
instance_type = "t3.large"
runner_version  = "2.308.0"
