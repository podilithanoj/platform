output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnets
}

output "tags" {
  description = "Tags which are applicable to all resources - map of `{key: value}` pairs"
  value       = local.tags
}

output "asg_tags" {
  description = "Tags which are appropriate auto scaling group (i.e. as a list of maps). See: https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html"
  value = [for key, val in local.tags :
    {
      key                 = key
      value               = val
      propagate_at_launch = true
    }
  ]
}
