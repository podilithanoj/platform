terraform {
  backend "s3" {}
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "glacade"         
    key    = "network/dev/terraform.tfstate"        
    region = "us-east-1"
  }
}

data "aws_caller_identity" "current" {}

locals {
  tags = {
    Application = var.application
    CreatedBy   = var.created_by
    DeployedBy  = data.aws_caller_identity.current.arn
    Environment = var.environment
    Repository  = var.repository
    business-category  = "reward"
    map-migrated       = "cashback"
    compliance         = "pci-dss-4"
  }
}

module "runner_stack" {
  source = "../../templates/workload/compute/runner_stack"

  vpc_id                    = data.terraform_remote_state.network.outputs.vpc_id
  private_subnet_ids        = data.terraform_remote_state.network.outputs.private_subnet_ids
  public_subnet_ids         = data.terraform_remote_state.network.outputs.public_subnet_ids

  key_name                  = var.key_name
  github_repo               = var.github_repo
  secret_name               = var.secret_name
  region                    = var.region
  ami_id                    = var.ami_id
  runner_version            = var.runner_version
  instance_type             = var.instance_type
  iam_instance_profile_name = var.iam_instance_profile_name
  name_prefix               = var.application
  runner_label              = var.runner_label
  environment              = var.environment
  asg_config               = var.asg_config
  tags                      = local.tags
}
