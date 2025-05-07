region                    = "us-west-2"
github_repo               = "podilithanoj/platform"
key_name                  = "Gl_bastion"  # Using existing key pair

ami_id                    = "ami-075686beab831bb7f"  # Ubuntu AMI in us-west-2
instance_type             = "t3.large"
runner_version            = "2.323.0"
iam_instance_profile_name = "session"
runner_label = "github-dev-runner"


environment        = "dev"
application        = "runner-app"
created_by         = "terraform"
repository         = "podilithanoj/platform"
secret_name = "github_pat_dev"

# ASG Configuration for development environment
asg_config = {
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  health_check_type         = "EC2"
  health_check_grace_period = 300
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
      instance_warmup        = 300
      checkpoint_delay       = 60
      checkpoint_percentages = [25, 50, 75, 100]
    }
  }
}
