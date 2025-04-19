name               = "java-app1-dev-vpc"
vpc_cidr           = "10.10.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnets    = ["10.10.11.0/24", "10.10.12.0/24"]
enable_nat_gateway = true
environment        = "dev"

