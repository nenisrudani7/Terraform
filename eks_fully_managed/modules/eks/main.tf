terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.19.0"
    }
  }
}

module "eks_cluster_role" {
  source       = "./iam"
  project_name = var.project_name
  module_name  = "precta_role"
}


resource "aws_eks_cluster" "precta_dev" {
  name     = "${var.project_name}_cluster"
  role_arn = module.eks_cluster_role.eks_cluster_role
  version  = var.eks_version
  enabled_cluster_log_types = ["audit", "api", "authenticator", "scheduler", "controllerManager"]
  vpc_config {
    subnet_ids           = var.subnet_ids
    public_access_cidrs  = var.eks_public_access_cidrs
  
  }
  depends_on = [module.eks_cluster_role]

  tags = {
     mode = "precta"
  }
 
}

module "demand_instance_nodegroup" {
  source        = "./node_group"
  project_name  = var.project_name
  module_name   = "dev_eks_node_role"
  cluster_name  = aws_eks_cluster.precta_dev.name
  node_role_arn = module.eks_cluster_role.node_role
  instance_type = var.instance_type
  desired_size  = var.desired_size
  min_size      = var.min_size
  max_size      = var.max_size
  subnet_ids    = var.nodegroup_subnet_ids
  usage_label   = var.usage_label
}

data "aws_iam_policy_document" "ebs_csi_irsa" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::127056275723:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/0B12270B9C4E484D081D2748A79D148F"]
    }

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.us-east-1.amazonaws.com/id/0B12270B9C4E484D081D2748A79D148F:sub"

      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "ebs_csi" {
  name               = "EBSIrsaDevCluster"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_irsa.json
}

resource "aws_iam_role_policy_attachment" "AmazonEBSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi.name
}


data "tls_certificate" "precta_dev" {
  url = aws_eks_cluster.precta_dev.identity.0.oidc.0.issuer
}
# resource "aws_iam_openid_connect_provider" "prectaoidc" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.precta_dev.certificates.0.sha1_fingerprint]
#   url             = aws_eks_cluster.precta_dev.identity.0.oidc.0.issuer
# }

resource "aws_iam_openid_connect_provider" "prectaoidc" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.precta_dev.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.precta_dev.identity.0.oidc.0.issuer

  depends_on = [aws_eks_cluster.precta_dev]
}


data "aws_iam_policy_document" "efs_csi_irsa" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::127056275723:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/0B12270B9C4E484D081D2748A79D148F"]
    }

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.us-east-1.amazonaws.com/id/0B12270B9C4E484D081D2748A79D148F:sub"

      values = [
        "system:serviceaccount:kube-system:efs-csi-controller-sa"
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "efs_csi" {
  name               = "EFSIrsaDevCluster"
  assume_role_policy = data.aws_iam_policy_document.efs_csi_irsa.json
}

resource "aws_iam_role_policy_attachment" "AmazonEFSCSIDriverPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi.name
}

resource "aws_eks_addon" "efs_csi" {
  cluster_name             = aws_eks_cluster.precta_dev.name
  addon_name               = "aws-efs-csi-driver"
  addon_version            = "v2.2.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.efs_csi.arn
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = aws_eks_cluster.precta_dev.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.54.1-eksbuild.1"
  service_account_role_arn = aws_iam_role.ebs_csi.arn
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.precta_dev.name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_create = "OVERWRITE"
  addon_version               = "v1.19.5-eksbuild.1"
}