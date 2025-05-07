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
    runner_label   = var.runner_label
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
    tags = merge(
      {
        Name = "${var.name_prefix}-github-runner"
      },
      var.tags
    )
  }
}

resource "aws_autoscaling_group" "runner_asg" {
  desired_capacity          = var.asg_config.desired_capacity
  max_size                 = var.asg_config.max_size
  min_size                 = var.asg_config.min_size
  health_check_type        = var.asg_config.health_check_type
  health_check_grace_period = var.asg_config.health_check_grace_period
  vpc_zone_identifier      = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.github_runner.id
    version = "$Latest"
  }

  dynamic "instance_refresh" {
    for_each = var.asg_config.instance_refresh != null ? [var.asg_config.instance_refresh] : []
    content {
      strategy = instance_refresh.value.strategy
      preferences {
        min_healthy_percentage = instance_refresh.value.preferences.min_healthy_percentage
        instance_warmup        = instance_refresh.value.preferences.instance_warmup
        checkpoint_delay       = instance_refresh.value.preferences.checkpoint_delay
        checkpoint_percentages = instance_refresh.value.preferences.checkpoint_percentages
      }
    }
  }

  dynamic "tag" {
    for_each = merge(
      {
        Name = "${var.name_prefix}-runner-asg"
      },
      var.tags
    )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
