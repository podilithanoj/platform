provider "aws" {
  region = var.region
}

resource "aws_security_group" "github_runner_sg" {
  name        = "${var.name_prefix}-runner-sg"
  description = "Allow minimal egress for GitHub self-hosted runner"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars = {
    github_repo    = var.github_repo
    runner_version = var.runner_version
    secret_name    = var.secret_name
    region         = var.region
  }
}

resource "aws_launch_template" "github_runner" {
  name_prefix   = "${var.name_prefix}-runner-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = base64encode(data.template_file.user_data.rendered)

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.github_runner_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-github-runner"
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
    value               = "${var.name_prefix}-runner-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
