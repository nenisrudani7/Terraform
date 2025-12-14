output "aws_key_pair" {
value = module.ssh-key.aws_key_pair
}

output "bastion_public_ip" {
  value = module.bastion_host.bastion_public_ip
}
output "bastion_private_ip" {
  value = module.bastion_host.bastion_private_ip 
}


output "public_subnet_az1_cidr" {
  value = module.vpc.public_subnet_az1_cidr
}

output "private_subnet_az1_cidr" {
  value = module.vpc.private_subnet_az1_cidr
  
}   

output "vpc_id" {
  value = module.vpc.vpc_id
}
output "bastion_security_group_id" {
  value = module.bastion_security_group.sg-bastion_host_id
}