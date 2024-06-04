locals {
  # -------------------------------------------------------------
  # AWS account settings
  # -------------------------------------------------------------
  env_account_id = {
    development = 891377286140
  }

  provider_region = {
    development = "eu-central-1"
  }

  # -------------------------------------------------------------
  # EKS cluster settings
  # -------------------------------------------------------------
  enable_eks = {
    development = true
    prod        = false # This is just an example of the capabilities of the module to hold more than one environment.
  }

  cluster_name = "docusketch-${terraform.workspace}-eks-cluster"

  eks_version = {
    development = "1.29"
  }
  cluster_namespaces = {
    development = ["development"]
  }
  amzn_eks_worker_ami_name = {
    development = "amazon-eks-node-1.29-v20240202"
  }
  workers_instance_type = {
    development = "t3a.micro"
  }
  keypair_name = {
    development = "eks-development" # This key was previously created by hand
  }
  boot_volume_size = {
    development = 20
  }
  encrypted_boot_volume = {
    development = false
  }
  asg_min_size = {
    development = 0
  }
  asg_desired_size = {
    development = 0
  }
  asg_max_size = {
    development = 0
  }
  create_master_role = {
    development = true
  }
  create_workers_role = {
    development = true
  }

  cluster_vpc_id = {
    development = "vpc-0cb31c4ff738fd717"
  }
  cluster_vpc_cidr = {
    development = ["172.4.0.0/16"]
  }
  cluster_public_subnets_ids = {
    development = [
      "subnet-0d936d196c0144af9",
      "subnet-06ce812ae9ec35a91",
      "subnet-07d602829bb14ac1f",
    ]
  }
  cluster_private_subnets_ids = {
    development = [
      "subnet-0573bed1c795c88dc",
      "subnet-03102a7ca35f58fbe",
      "subnet-070848540bcc92a7a",
    ]
  }

  # -------------------------------------------------------------
  # EKS node groups settings
  # -------------------------------------------------------------
  create_ng_role = {
    development = true
  }
  node_groups = {
    development = [
      {
        "name"                        = "Development-NG-OnDemand"
        "scaling_config_min_size"     = 1
        "scaling_config_desired_size" = 1
        "scaling_config_max_size"     = 1
        "disk_size"                   = 20
        "instance_types"              = ["t3a.small"]
        "release_version"             = "1.29.0-20240202" # This can ve checked here: https://github.com/awslabs/amazon-eks-ami/releases
        "k8s_version"                 = "1.29"
        "capacity_type"               = "ON_DEMAND"
        "ec2_pricing_model"           = "on-demand"
      },
      {
        "name"                        = "Development-NG-Spot"
        "scaling_config_min_size"     = 1
        "scaling_config_desired_size" = 1
        "scaling_config_max_size"     = 2
        "disk_size"                   = 20
        "instance_types"              = ["t3a.micro", "t3.micro", ]
        "release_version"             = "1.29.0-20240202"
        "k8s_version"                 = "1.29"
        "capacity_type"               = "SPOT"
        "ec2_pricing_model"           = "spot"
      }
    ]
  }

  # -------------------------------------------------------------
  # K8s settings
  # -------------------------------------------------------------
  eks_users_access = {
    development = [
      {
        user_arn = "arn:aws:iam::637423388572:user/ds_challenge"
        username = "ds_challenge"
        group    = "system:masters" # cluster-admin
      },
    ]
  }

  eks_roles_access = {
    development = []
  }

  priority_classes = {
    development = [
      {
        name        = "monitoring-critical"
        value       = 1900001
        description = "Used for pods that are critical for monitoring workloads."
      }
    ]
  }

  # -------------------------------------------------------------
  # Helm charts settings
  # -------------------------------------------------------------
  deploy_charts = {
    development = true
  }
  master_role_arn = {
    development = "arn:aws:iam::637423388572:role/K8sMastersRole"
  }
  workers_role_arn = {
    development = "arn:aws:iam::637423388572:role/K8sWorkersRole"
  }
  ng_role_arn = {
    development = "arn:aws:iam::637423388572:role/EksNodeGroupRole"
  }

  # -------------------------------------------------------------
  # EKS Addons settings
  # -------------------------------------------------------------
  general_addons_tags = {
    project       = "DocuSketch"
    owner         = "DocuSketch-DevOps"
    created_using = "terraform"
    service       = "compute"
    name          = "docusketch"
  }
  vpc_cni = {
    development = {
      enabled   = true
      version   = "v1.16.2-eksbuild.1"
      conflicts = "OVERWRITE"
      tags = merge(local.general_addons_tags,
        {
          Name        = "VPC-CNI"
          Version     = "v1.16.2-eksbuild.1"
          environment = "development"
        }
      )
    }
  }
  kube_proxy = {
    development = {
      enabled   = true
      version   = "v1.29.0-eksbuild.2"
      conflicts = "OVERWRITE"
      tags = merge(local.general_addons_tags,
        {
          Name        = "Kube Proxy"
          Version     = "v1.29.0-eksbuild.2"
          environment = "development"
        }
      )
    }
  }
  coredns = {
    development = {
      enabled   = true
      version   = "v1.11.1-eksbuild.4"
      conflicts = "OVERWRITE"
      tags = merge(local.general_addons_tags,
        {
          Name        = "CoreDNS"
          version     = "v1.11.1-eksbuild.4"
          environment = "development"
        }
      )
    }
  }
  # -------------------------------------------------------------
  # IRSA settings
  # -------------------------------------------------------------
  oidc_arn = {
    development = "arn:aws:iam::891377286140:oidc-provider/oidc.eks.eu-central-1.amazonaws.com/id/F0CDE42B11A4D94D7632290980C93A90"
  }
  irsa_policies = {
    development = {
      cluster-autoscaler = {
        create_policy    = true
        name             = "AmazonEKSClusterAutoscalerPolicy"
        path             = "/"
        description      = "This policy allows ClusterAutoscaler to manage EC2 instances"
        policy           = "${path.module}/policies/cluster-autoscaler.json"
        tags             = { environment = terraform.workspace }
        policy_variables = {}
      }
    }
  }

  irsa_roles = {
    development = {
      cluster-autoscaler = {
        create_role = true
        role_name   = "ClusterAutoscaler"
        assume_role_policy = templatefile("${path.module}/policies/irsa_trust_policy.json", {
          provider_arn              = local.oidc_arn[terraform.workspace],
          issuer_hostpath           = replace(local.oidc_arn[terraform.workspace], "arn:aws:iam::${local.env_account_id[terraform.workspace]}:oidc-provider/", ""),
          service_account_namespace = "kube-system",
          service_account_name      = "cluster-autoscaler",
        })
        max_session_duration = 3600
        role_description     = "This role is required by ClusterAutoscaler"
        policy_arn           = ["arn:aws:iam::${local.env_account_id[terraform.workspace]}:policy/AmazonEKSClusterAutoscalerPolicy"]
        tags                 = { environment = terraform.workspace }
      }
    }
  }

  irsa_service_accounts = {
    development = [
      {
        name      = "cluster-autoscaler"
        namespace = "kube-system"
        role_arn  = "arn:aws:iam::${local.env_account_id[terraform.workspace]}:role/ClusterAutoscaler"
      }
    ]
  }
}
