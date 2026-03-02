output "ec2_public_ips" {
  description = "Public IP addresses of both EC2 instances"
  value       = { for k, v in aws_instance.ubuntu : k => v.public_ip }
}

output "ec2_private_ips" {
  description = "Private IP addresses of both EC2 instances"
  value       = { for k, v in aws_instance.ubuntu : k => v.private_ip }
}

output "private_key_path" {
  description = "Path to the SSH private key file"
  value       = "terraform-key.pem (saved in project directory)"
}

output "ssh_commands" {
  description = "SSH commands to connect to each instance"
  value       = { for k, v in aws_instance.ubuntu : k => "ssh -i terraform-key.pem ubuntu@${v.public_ip}" }
}
