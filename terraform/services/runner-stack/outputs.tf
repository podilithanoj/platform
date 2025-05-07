output "asg_name" {
  value = module.runner_stack.asg_name
}

output "launch_template_id" {
  value = module.runner_stack.launch_template_id
}

output "rendered_user_data_debug" {
  value = module.runner_stack.rendered_user_data
}
