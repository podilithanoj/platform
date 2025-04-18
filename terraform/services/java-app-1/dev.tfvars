name               = "java-app1-dev-vpc"
environment        = "dev"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
enable_nat_gateway = true

ami                = "ami-084568db4383264d4"
instance_type      = "t2.micro"
ec2_name           = "java-app1-dev-instance"
