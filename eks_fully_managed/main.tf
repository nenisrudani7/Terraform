module "vpc" {
  source                  = "./modules/vpc"
  region                  = var.region
  project_name            = var.project_name
  cluster_name            = var.cluster_name
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
  oidc_arn             = "arn:aws:iam::887675945169:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/CD5C4D5C22FE4F17D80211C0B33D7582"
  oidc_url             = "data.aws_eks_cluster.precta_dev.identity[0].oidc[0].issuer"
}




