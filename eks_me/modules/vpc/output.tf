output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_id" {
  value = aws_subnet.subnet[*].id
}
output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.name
}
# output "security_group_id" {
#   value = aws_security_group.security_group.id
# }
output "availability_zone" {
  value = aws_subnet.subnet[*].availability_zone
}
output "cidr_block_vpc" {
  value = aws_vpc.my_vpc.cidr_block
}