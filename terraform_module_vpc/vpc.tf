module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
    for_each = {
    env1 = "dev"
    env2 = "prd"
  }


  name = "${each.value}-vpc-terrafrom"
  cidr = "10.0.0.0/16"

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets


  enable_nat_gateway = true
  enable_vpn_gateway = true





  tags = {
    Terraform   = "true"
    Environment = each.value
  }
}