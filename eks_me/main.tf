module "vpc" {
  source            = "./modules/vpc"
  env               = var.env
  cidr_block_vpc    = var.cidr_block_vpc
  cidr_block_sn1    = var.cidr_block_sn1
  availability_zone = var.availability_zone
  cidr_block_route  = var.cidr_block_route

}

module "security_group" {
  source              = "./modules/security_groups"
  env                 = var.env
  ingress_cidr_blocks = var.ingress_cidr_blocks
  egress_cidr_blocks  = var.egress_cidr_blocks
  inbound_ports       = var.inbound_ports
  vpc_id              = module.vpc.vpc_id
}