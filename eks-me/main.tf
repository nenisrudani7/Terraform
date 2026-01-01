module "vpc" {
  source          = "./modules/vpc"
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  intra_subnets   = var.intra_subnets
  tags            = var.tags
}

# module "security_group" {
#   source = "./modules/security_groups"
#   name        = var.sg_name
#   vpc_id      = module.vpc.vpc_id
#   vpc_cidr    = var.vpc_cidr
#   tags        = var.tags
#   environment = var.environment
# }


# module "eks" {
#   source = "./modules/eks"
#   cluster_name              = var.cluster_name
#   cluster_version           = var.cluster_version
#   environment               = var.environment
#   vpc_id                    = module.vpc.vpc_id
#   subnet_ids                = module.vpc.public_subnets
#   control_plane_subnet_ids  = module.vpc.private_subnets
#   bastion_security_group_id = module.security_group.bastion_security_group_id
#   eks_addon_versions = var.eks_addon_versions
#   tags = var.tags
# }
