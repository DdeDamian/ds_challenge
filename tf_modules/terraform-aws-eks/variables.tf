# -------------------------------------------------------------
# Network variables
# -------------------------------------------------------------

variable "vpc_id" {
  description = "The ID of the VPC where we are deploying the EKS cluster"
  type        = string
}

variable "vpc_cidr" {
  type        = list(string)
  description = "The CIDR range used in the VPC"
}

variable "public_subnets_ids" {
  description = "The IDs of at least two public subnets for the K8S control plane ENIs"
  type        = list(string)
}

variable "private_subnets_ids" {
  description = "The IDs of at least two private subnets to deploy the K8S workers in"
  type        = list(string)
}

# -------------------------------------------------------------
# EKS variables
# -------------------------------------------------------------

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "environment" {
  description = "The environment where you want to create the VPC and depending resources"
  type        = string
}

variable "amzn_eks_worker_ami_name" {
  description = "The name of the AMI to be used. Right now only supports Amazon Linux2 based EKS worker AMI"
  type        = string
}

variable "k8s_version" {
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version is used."
  type        = string
  default     = ""
}

variable "create_asg" {
  description = "Enables the creation of the ASG."
  type        = bool
  default     = false
}

variable "create_autoscaling_policy" {
  description = "true if you want to create autoscaling policy for CA"
  type        = bool
  default     = false
}

variable "create_route53_policy" {
  description = "true if you want to create route53 policy for external-dns"
  type        = bool
  default     = false
}

variable "encrypted_boot_volume" {
  description = "If true, an encrypted EKS AMI will be created to support encrypted boot volumes"
  type        = bool
}

variable "workers_instance_type" {
  description = "The instance type for the K8S workers"
  type        = string
}

variable "keypair_name" {
  description = "The name of an existing key pair to access the K8S workers via SSH"
  type        = string
  default     = ""
}

variable "boot_volume_type" {
  description = "The type of volume to allocate [gp2|io1]"
  type        = string
  default     = "gp2"
}

variable "iops" {
  description = "The amount of provisioned IOPS if volume type is io1"
  default     = 0
  type        = number
}

variable "boot_volume_size" {
  description = "The size of the root volume in GBs"
  type        = number
}

variable "asg_min_size" {
  description = "The minimum size of the autoscaling group for K8S workers"
  type        = number
}

variable "asg_desired_size" {
  description = "The number of instances that should be running in the ASG"
  type        = number
}

variable "asg_max_size" {
  description = "The maximum size of the autoscaling group for K8S workers"
  type        = number
}

variable "asg_tags" {
  description = "Map containig default ASG tags."
  type = list(object(
    {
      key                 = string
      value               = string
      propagate_at_launch = bool
  }))
  default = []
  # example = [
  #   {
  #     key                 = "Name"
  #     value               = "${var.cluster_name}-worker"
  #     propagate_at_launch = true
  #   },
  #   {
  #     key                 = "kubernetes.io/cluster/${var.cluster_name}"
  #     value               = "owned"
  #     propagate_at_launch = true
  #   },
  #   {
  #     key                 = "k8s.io/cluster-autoscaler/enabled"
  #     value               = "true"
  #     propagate_at_launch = true
  #   },
  #   {
  #     key                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
  #     value               = "true"
  #     propagate_at_launch = true
  #   },
  # ]
}

variable "lb_target_group" {
  description = "The App LB target group ARN we want this AutoScaling Group belongs to"
  type        = string
  default     = ""
}

variable "k8s_namespaces" {
  description = "This variable will define the namespaces to be created and then used by k8s cluster to make the role binding. Remember that `default` namespace is already set."
  type        = list(string)
}

variable "map_users" {
  description = "A list of maps with the IAM users allowed to access EKS"
  type = list(object(
    {
      user_arn = string
      username = string
      group    = string
  }))
  default = []

  # example:
  #
  #  map_users = [
  #    {
  #      user_arn = "arn:aws:iam::<aws-account>:user/JohnSmith"
  #      username = "john"
  #      group    = "system:masters" # cluster-admin
  #    },
  #    {
  #      user_arn = "arn:aws:iam::<aws-account>:user/PeterMiller"
  #      username = "peter"
  #      group    = "ReadOnlyGroup"  # custom role granting read-only permissions
  #    }
  #  ]
  #
}

variable "map_roles" {
  description = "A list of maps with the roles allowed to access EKS"
  type = list(object(
    {
      role_arn = string
      username = string
      group    = string
  }))
  # example:
  #
  #  map_roles = [
  #    {
  #      role_arn = "arn:aws:iam::<aws-account>:role/ReadOnly"
  #      username = "john"
  #      group    = "system:masters" # cluster-admin
  #    },
  #    {
  #      role_arn = "arn:aws:iam::<aws-account>:role/Admin"
  #      username = "peter"
  #      group    = "ReadOnlyGroup"  # custom role granting read-only permissions
  #    }
  #  ]
  #
}

variable "priority_classes" {
  type = list(object(
    {
      name        = string
      value       = number
      description = string
    }
  ))
  description = "List of all the priority classes needed to assure system stability"
}

variable "oidc_thumbprint_list" {
  description = "A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)."
  type        = list(string)
  default     = []
}

variable "create_master_role" {
  description = "Enables creation of Master Role"
  type        = bool
  default     = false
}

variable "create_workers_role" {
  description = "Enables creation of Workers Role"
  type        = bool
  default     = false
}

variable "create_ng_role" {
  description = "Enables creation of EksNodeGroupRole Role"
  type        = bool
  default     = false
}

variable "master_role_arn" {
  description = "ARN of the master role"
  type        = string
  default     = ""
}

variable "workers_role_arn" {
  description = "ARN of the workers role"
  type        = string
  default     = ""
}

variable "ng_role_arn" {
  description = "ARN of the node group role"
  type        = string
  default     = ""
}

# -------------------------------------------------------------
# Security variables
# -------------------------------------------------------------

variable "allow_app_ports" {
  description = "A list of TCP ports to open in the K8S workers SG for instances/services in the VPC"
  type        = list(number)
  default     = [22]
}

# -------------------------------------------------------------
# Tagging
# -------------------------------------------------------------

variable "general_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "security_groups_tags" {
  description = "A map of tags needed to describe the Security groups"
  type        = map(string)
  default     = {}
}

variable "encrypted_ami_tags" {
  description = "A map of tags needed to identify the encripted ami"
  type        = map(string)
  default     = {}
}

variable "oidc_tags" {
  description = "A map of tags to describe the OIDC"
  type        = map(string)
  default     = {}
}

# -------------------------------------------------------------
# Node Groups
# -------------------------------------------------------------

variable "node_groups" {
  description = "A list of maps with the configuration for each node group"
  type = list(object(
    {
      name                        = string
      scaling_config_desired_size = number
      scaling_config_max_size     = number
      scaling_config_min_size     = number
      disk_size                   = number
      instance_types              = list(string)
      release_version             = string
      k8s_version                 = string
      capacity_type               = string
      ec2_pricing_model           = string
  }))

  # example:
  #
  #  node_groups = [
  #    {
  #      name                        = "main"
  #      scaling_config_desired_size = "1"
  #      scaling_config_max_size     = "2"
  #      scaling_config_min_size     = "1"
  #      disk_size                   = "20"
  #      instance_types              = "t2.medium"
  #      release_version             = "1.29.12-20200710"
  #      k8s_version                 = "1.29"
  #      capacity_type               = "ON_DEMAND"
  #      ec2_pricing_model           = "on-demand"
  #     },
  #    {
  #      name                        = "secondary"
  #      scaling_config_desired_size = "1"
  #      scaling_config_max_size     = "2"
  #      scaling_config_min_size     = "1"
  #      disk_size                   = "20"
  #      instance_types              = "t2.small"
  #      release_version             = "1.29.12-20200710"
  #      k8s_version                 = "1.29"
  #      capacity_type               = "SPOT"
  #      ec2_pricing_model           = "spot"
  #     },
  #  ]
  #
}

# -------------------------------------------------------------
# Helm charts
# -------------------------------------------------------------

variable "charts" {
  description = "A map of values needed to create a new helm release"
  type        = any
  default     = {}
  # example:
  #
  # charts = {
  # "nginx-test" = {
  #   name             = "nginx-test"
  #   repository       = "https://charts.bitnami.com/bitnami"
  #   chart            = "nginx"
  #   namespace        = "devops-testing-helm"
  #   version          = "6.2.0"
  #   values           = ["${path.cwd}/helm_values/chart/values.yaml"]
  #   create_namespace = true
  #   set_sensitive    = [
  #     {
  #       name = "nameOverride"
  #       value = data.aws_kms_secrets.helm-secrets.plaintext["name-override"]
  #       type = "string"
  #     },
  #     {
  #       name = "pullPolicy"
  #       value = data.aws_kms_secrets.helm-secrets.plaintext["pull-policy"]
  #       type = "string"
  #     }
  #   ]
  # }
  #}
}

variable "deploy_charts" {
  description = "Enables the helm charts deployment"
  type        = bool
  default     = false
}

variable "lint" {
  description = "Run the helm chart linter during the plan"
  type        = bool
  default     = false
}

variable "wait" {
  description = "Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout"
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks)"
  type        = number
  default     = 300
}

# -------------------------------------------------------------
# IRSA variables
# -------------------------------------------------------------

variable "irsa_service_accounts" {
  description = "Service accounts meant to be used with IRSA"
  type = list(object({
    name      = string,
    namespace = string,
    role_arn  = string
  }))
  default = []
}
