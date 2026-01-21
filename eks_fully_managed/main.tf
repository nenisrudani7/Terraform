module "vpc" {
  source                  = "./modules/vpc"
  region                  = var.region
  project_name            = var.project_name
  vpc_cidr                = var.vpc_cidr
  public_subnet_az1_cidr  = var.public_subnet_az1_cidr
  public_subnet_az2_cidr  = var.public_subnet_az2_cidr
  private_subnet_az1_cidr = var.private_subnet_az1_cidr
  private_subnet_az2_cidr = var.private_subnet_az2_cidr
  enable_nat_gateway      = var.enable_nat_gateway

}

module "precta" {
  source               = "./modules/eks"
  cluster_name         = var.cluster_name
  module_name          = "eks_precta_custer"
  project_name         = var.project_name
  subnet_ids           = [module.vpc.private_subnet_az1, module.vpc.private_subnet_az2, module.vpc.public_subnet_az1, module.vpc.public_subnet_az2]
  eks_version          = "1.32"
  desired_size         = var.desired_size
  nodegroup_subnet_ids = [module.vpc.private_subnet_az1, module.vpc.private_subnet_az2]
  min_size             = var.min_size
  max_size             = var.max_size
  instance_type        = ["t3.medium", "t3.large"]
  usage_label          = "precta"
}

 