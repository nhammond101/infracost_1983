output "aws_region_zones" {
  description = "The Availability Zones for the region"
  value       = local.aws_region_zones
}

output "nat_gateway_ids" {
  description = "The NAT gateways IDs"
  value       = module.base-network.nat_gw_ids
}

output "private_subnets_ids" {
  description = "The private subnet IDs"
  value       = module.base-network.private_subnets_ids
}

output "public_subnets_ids" {
  description = "The public subnet IDs"
  value       = module.base-network.public_subnets_ids
}

output "security_group_id_default" {
  description = "The VPC default security group ID"
  value       = data.aws_security_groups.default.ids
}

output "subnet_cidrblocks" {
  description = "The private/public CIDR blocks generated"
  value = {
    private = local.private_subnet_cidrs
    public  = local.public_subnet_cidrs
  }
}

output "vpc_id" {
  description = "The VPC ID"
  value       = module.base-network.vpc_id
}
