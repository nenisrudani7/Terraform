# output "ec2_public_ip" {
#   value = aws_instance.demo[*].public_ip
# }

# output "ec2_public_dns" {
#   value = aws_instance.demo[*].public_dns
# }

# output "ec2_private_ip" {
#   value = aws_instance.demo[*].private_ip
# }

# to print ip address using for_each
output "ec2_public_ip" {
  value = [
    for instance_ip in aws_instance.demo : instance_ip.public_ip
  ]
}