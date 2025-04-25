provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "github_runner_sg" {
  name        = "runner-sg"
  description = "Allow all egress"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    github_token = var.github_token
    github_repo  = var.github_repo
    runner_version = var.runner_version
  }
}

resource "aws_launch_template" "github_runner" {
  name_prefix   = "runner-GitHub"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = base64encode(data.template_file.user_data.rendered)

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.github_runner_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "GitHubRunner"
    }
  }
}

resource "aws_autoscaling_group" "runner_asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.github_runner.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "runner-dev-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
