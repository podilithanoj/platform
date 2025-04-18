
output "vpc_id" {
  description = "VPC ID"
  value       = module.wrapped_vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.wrapped_vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.wrapped_vpc.private_subnets
}
