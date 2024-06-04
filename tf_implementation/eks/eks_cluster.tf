module "main_eks_cluster" {
  source = "./../../tf_modules/terraform-aws-eks/"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  # Network settings`
  vpc_id              = local.cluster_vpc_id[terraform.workspace]
  vpc_cidr            = local.cluster_vpc_cidr[terraform.workspace]
  public_subnets_ids  = local.cluster_public_subnets_ids[terraform.workspace]
  private_subnets_ids = local.cluster_private_subnets_ids[terraform.workspace]

  # EKS cluster settings
  environment              = terraform.workspace
  cluster_name             = local.cluster_name
  k8s_version              = local.eks_version[terraform.workspace]
  amzn_eks_worker_ami_name = local.amzn_eks_worker_ami_name[terraform.workspace]
  workers_instance_type    = local.workers_instance_type[terraform.workspace]
  keypair_name             = local.keypair_name[terraform.workspace]
  boot_volume_size         = local.boot_volume_size[terraform.workspace]
  encrypted_boot_volume    = local.encrypted_boot_volume[terraform.workspace]
  asg_min_size             = local.asg_min_size[terraform.workspace]
  asg_desired_size         = local.asg_desired_size[terraform.workspace]
  asg_max_size             = local.asg_max_size[terraform.workspace]

  # Node group
  create_ng_role = local.create_ng_role[terraform.workspace]
  ng_role_arn    = local.ng_role_arn[terraform.workspace]
  node_groups    = local.node_groups[terraform.workspace]

  # K8s settings
  create_master_role  = local.create_master_role[terraform.workspace]
  create_workers_role = local.create_workers_role[terraform.workspace]
  map_roles           = local.eks_roles_access[terraform.workspace]
  map_users           = local.eks_users_access[terraform.workspace]
  k8s_namespaces      = local.cluster_namespaces[terraform.workspace]
  priority_classes    = local.priority_classes[terraform.workspace]
  master_role_arn     = local.master_role_arn[terraform.workspace]
  workers_role_arn    = local.workers_role_arn[terraform.workspace]

  # Helm charts
  deploy_charts         = local.deploy_charts[terraform.workspace]
  irsa_service_accounts = local.irsa_service_accounts[terraform.workspace]

  charts = {
    "cluster-autoscaler" = {
      repository       = "https://kubernetes.github.io/autoscaler"
      chart            = "cluster-autoscaler"
      namespace        = "kube-system"
      version          = "9.35.0"
      values           = ["${path.cwd}/helm/cluster-autoscaler/vars/${terraform.workspace}/values.yaml"]
      create_namespace = false
    },
  }
}
