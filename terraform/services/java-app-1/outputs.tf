output "private_subnet_ids" {
  value = slice(module.vpc.private_subnets, 0, length(var.private_subnets))
}

output "data_subnet_ids" {
  value = slice(module.vpc.private_subnets, length(var.private_subnets), length(module.vpc.private_subnets))
}

output "private_route_table_ids" {
  value = slice(module.vpc.private_route_table_ids, 0, length(var.private_subnets))
}

output "data_route_table_ids" {
  value = slice(module.vpc.private_route_table_ids, length(var.private_subnets), length(module.vpc.private_route_table_ids))
}
