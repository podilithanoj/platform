output "asg_name" {
  value = aws_autoscaling_group.runner_asg.name
}

output "launch_template_id" {
  value = aws_launch_template.github_runner.id
}