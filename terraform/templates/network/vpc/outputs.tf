output "private_subnets" {
  description = "List of all private subnets (including data subnets if merged)"
  value       = module.vpc.private_subnets
}

