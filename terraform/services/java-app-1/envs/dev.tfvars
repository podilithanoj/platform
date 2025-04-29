name               = "runner-dev-vpc"
vpc_cidr           = "10.220.12.0/22"
availability_zones = ["us-east-1a", "us-east-1b"]

public_subnets     = ["10.220.15.0/26", "10.220.15.64/26"]
private_subnets    = ["10.220.12.0/24", "10.220.13.0/24"]
data_subnets       = ["10.220.14.0/25", "10.220.14.128/25"]

enable_nat_gateway = true
enable_ipv6        = false

environment        = "dev"
application        = "runner-app"
created_by         = "terraform"

repository         = "podilithanoj/platform"            # ✅ FIXED — not a URL
key_name           = "runner"

github_repo        = "podilithanoj/platform"            # ✅ FIXED — GitHub expects org/repo

ami_id             = "ami-0d59d17fb3b322d0b"
instance_type      = "t3.large"
runner_version     = "2.323.0"
iam_instance_profile_name = "session"

region             = "us-east-1"                        # ✅ REQUIRED for secrets & region access
secret_name        = "github_token"                     # ✅ Matches Secrets Manager name
