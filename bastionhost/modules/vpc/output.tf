output "public_subnet_az1_cidr" {
    value = aws_subnet.public_subnet_az1.id
}
output "private_subnet_az1_cidr" {
value = aws_subnet.private_subnet_az1.id
}

output "vpc_id" {
  value = aws_vpc.prac.id
}