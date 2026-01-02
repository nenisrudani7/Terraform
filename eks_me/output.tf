output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}
output "db_subnet_group" {
  value = module.vpc.db_subnet_group
}
# output "security_group_id" {
#   value = module.vpc.security_group_id
# }
output "availability_zone" {
  value = module.vpc.availability_zone
}
output "cidr_block_vpc" {
  value = module.vpc.cidr_block_vpc
}

output "sg_groups_id" {
  value = module.security_group.sg_groups_id
}

# ---eks
output "cluster_arn" {
  value = module.eks.cluster_arn
}