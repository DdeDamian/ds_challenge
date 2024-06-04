# -------------------------------------------------------------
# AWS EKS cluster addons
# -------------------------------------------------------------

module "cluster_addon_vpc_cni" {
  source = "./../../tf_modules/terraform-aws-eks-addons/"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  enabled        = local.vpc_cni[terraform.workspace].enabled
  addon_name     = "vpc-cni"
  cluster_name   = local.cluster_name
  addon_version  = local.vpc_cni[terraform.workspace].version
  addon_conflict = local.vpc_cni[terraform.workspace].conflicts
  addon_tags     = local.vpc_cni[terraform.workspace].tags

  depends_on = [module.main_eks_cluster]

}

module "cluster_addon_kube_proxy" {
  source = "./../../tf_modules/terraform-aws-eks-addons/"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  enabled        = local.kube_proxy[terraform.workspace].enabled
  addon_name     = "kube-proxy"
  cluster_name   = local.cluster_name
  addon_version  = local.kube_proxy[terraform.workspace].version
  addon_conflict = local.kube_proxy[terraform.workspace].conflicts
  addon_tags     = local.kube_proxy[terraform.workspace].tags

  depends_on = [module.main_eks_cluster]

}

module "cluster_addon_coredns" {
  source = "./../../tf_modules/terraform-aws-eks-addons/"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  enabled        = local.coredns[terraform.workspace].enabled
  addon_name     = "coredns"
  cluster_name   = local.cluster_name
  addon_version  = local.coredns[terraform.workspace].version
  addon_conflict = local.coredns[terraform.workspace].conflicts
  addon_tags     = local.coredns[terraform.workspace].tags

  depends_on = [module.main_eks_cluster]

}
