# module "s3" {
#   source = "./modules/s3"
#   aws_s3_bucket = "practiseurspose12"
# }

# module "s3_2" {
#   source = "./modules/s3"
#   aws_s3_bucket = "practiseurspose1234"
# }



module "ssh-key"{
  source = "./modules/ssh-key"
  key_path = "./modules/ssh-key/bastionhost.pub"
  key_name = "bastion-key_pair"
}
module "ssh-key-main"{
  source = "./modules/ssh-key"
  key_path = "./modules/ssh-key/mainec2.pub"
  key_name = "main-key_pair"
}
#  
module "vpc" {
  source = "./modules/vpc"
  private_subnet_az1_cidr = "10.128.10.0/24"
  public_subnet_az1_cidr = "10.128.1.0/24"
}


module "bastion_host" {
  source = "./modules/ec2"
  ami = "ami-0f9de6e2d2f067fca" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  type = "t2.micro"
  keyname = module.ssh-key.aws_key_pair
  subnets = module.vpc.public_subnet_az1_cidr
  associate_public_ip_address = true
  security_groups = module.bastion_security_group.sg-bastion_host_id
  root_volume_size = 8
}


module "main_host" {
  source = "./modules/ec2"
  ami = "ami-0f9de6e2d2f067fca" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  type = "t2.micro"
  keyname = module.ssh-key-main.aws_key_pair
  subnets = module.vpc.private_subnet_az1_cidr
  associate_public_ip_address = false
  security_groups = module.bastion_security_group_main.sg-bastion_host_id 
  root_volume_size = 8
}

module "bastion_security_group" {
  sg_name             = "precta-bastion-terraform-security-groups"
  source              = "./modules/sg"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  inbound_ports       = [22, 80]
  vpc_id              = module.vpc.vpc_id
}

module "bastion_security_group_main" {
  sg_name             = "precta-main-terraform-security-groups"
  source              = "./modules/sg"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  inbound_ports       = [22]
  vpc_id              = module.vpc.vpc_id
}
