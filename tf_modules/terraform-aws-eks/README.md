# AWS EKS Terraform module

Terraform module which creates an AWS EKS Kubernetes cluster in a given VPC.

- [Amazon EKS](https://aws.amazon.com/eks/)

The module supports encryption at rest. In that case the official AMI is copied and encrypted so workers are launched from the encrypted image making the EBS boot volume encrypted by default at launch time.

When the cluster is created, the config map aws-auth is deployed by default, allowing the workers to join the masters automatically. Also, a service account for Tiller (server-side of Helm) is created with cluster-admin permissions, so you can deploy Charts on top of this cluster.

Lastly, some additional IAM policies are created and attached to the worker nodes so features like cluster autoscaler or external-DNS can be implemented without additional work from the IAM side.

## Usage

You'll need to have your AWS_PROFILE loaded up. Once you do, the module will ask you for the variables that you'll want to set as seen below (e.g.):

### Example

```hcl
module "eks_cluster" {
  source = "./tf_modules/terraform-aws-eks/"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  # Network settings`
  vpc_id              = module.vpc.vpc_id
  vpc_cidr            = module.vpc.vpc_cidr_block
  public_subnets_ids  = [module.vpc.public_subnets]
  private_subnets_ids = [module.vpc.private_subnets]

  # EKS cluster settings
  environment              = terraform.workspace
  cluster_name             = "my-test-cluster"
  k8s_version              = "1.29"
  amzn_eks_worker_ami_name = "amazon-eks-node-1.29-v20240202"
  workers_instance_type    = "t3a.micro"
  keypair_name             = "my-key"
  boot_volume_size         = "20"
  encrypted_boot_volume    = "false"
  asg_min_size             = "2"
  asg_desired_size         = "3"
  asg_max_size             = "4"

  # Node group
  create_ng_role = true
  ng_role_arn    = local.ng_role_arn[terraform.workspace]
  node_groups    = [
    {
      "name"                        = "Development-NG-OnDemand"
      "scaling_config_min_size"     = 1
      "scaling_config_desired_size" = 1
      "scaling_config_max_size"     = 1
      "disk_size"                   = 20
      "instance_types"              = ["t3a.small"]
      "release_version"             = "1.29.0-20240202" 
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

```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6.0 |
| helm | >= 2.12.0 |
| kubernetes | >= 2.25.0 |
| template | >= 2.2.0 |
| tls | >= 4.0.0 |
| version | >= 5.52.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| helm | >= 2.12.0 |
| kubernetes | >= 2.25.0 |
| template | >= 2.2.0 |
| tls | >= 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ami_copy.encrypted_eks_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami_copy) | resource |
| [aws_autoscaling_group.workers_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_eks_cluster.masters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.workers_ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_instance_profile.iam_workers_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_openid_connect_provider.cluster_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy.autoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.route53_recordsets_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.k8s_masters_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.k8s_workers_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ng](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_autoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.attach_route53_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ng-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ng-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ng-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ng-attach_autoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ng-attach_route53_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_configuration.workers_launch_config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_security_group.k8s_masters_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.k8s_workers_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.app_inbound_traffic_workers_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.masters_inbound_traffic_workers_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.outbound_traffic_masters_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.outbound_traffic_workers_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.self_traffic_workers_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.workers_inbound_443_traffic_masters_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [helm_release.chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_cluster_role.ro_nodes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.power_user](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_cluster_role_binding.ro_nodes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_config_map.aws_auth_cm](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_namespace.environment_namespaces](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_priority_class.k8s_priority_classes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/priority_class) | resource |
| [kubernetes_role_binding.scoped_power_user](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_service_account.irsa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [aws_ami.amazon_eks_workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_eks_cluster.masters](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.masters_auth](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |
| [aws_iam_policy_document.autoscaling_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.k8s_masters_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.k8s_ng_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.k8s_workers_role_role_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.route53_recordsets_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [template_file.map_roles](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.map_users](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.node_group_worker_role_arns](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.worker_role_arns](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [tls_certificate.cluster_tls_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow_app_ports | A list of TCP ports to open in the K8S workers SG for instances/services in the VPC | `list(number)` | ```[ 22 ]``` | no |
| amzn_eks_worker_ami_name | The name of the AMI to be used. Right now only supports Amazon Linux2 based EKS worker AMI | `string` | n/a | yes |
| asg_desired_size | The number of instances that should be running in the ASG | `number` | n/a | yes |
| asg_max_size | The maximum size of the autoscaling group for K8S workers | `number` | n/a | yes |
| asg_min_size | The minimum size of the autoscaling group for K8S workers | `number` | n/a | yes |
| asg_tags | Map containing default ASG tags. | ```list(object( { key = string value = string propagate_at_launch = bool }))``` | `[]` | no |
| boot_volume_size | The size of the root volume in GBs | `number` | n/a | yes |
| boot_volume_type | The type of volume to allocate [gp2\|io1] | `string` | `"gp2"` | no |
| charts | A map of values needed to create a new helm release | `any` | `{}` | no |
| cluster_name | The name of the EKS cluster | `string` | n/a | yes |
| create_asg | Enables the creation of the ASG. | `bool` | `false` | no |
| create_autoscaling_policy | true if you want to create autoscaling policy for CA | `bool` | `false` | no |
| create_master_role | Enables creation of Master Role | `bool` | `false` | no |
| create_ng_role | Enables creation of EksNodeGroupRole Role | `bool` | `false` | no |
| create_route53_policy | true if you want to create route53 policy for external-dns | `bool` | `false` | no |
| create_workers_role | Enables creation of Workers Role | `bool` | `false` | no |
| deploy_charts | Enables the helm charts deployment | `bool` | `false` | no |
| encrypted_ami_tags | A map of tags needed to identify the encrypted ami | `map(string)` | `{}` | no |
| encrypted_boot_volume | If true, an encrypted EKS AMI will be created to support encrypted boot volumes | `bool` | n/a | yes |
| environment | The environment where you want to create the VPC and depending resources | `string` | n/a | yes |
| general_tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| iops | The amount of provisioned IOPS if volume type is io1 | `number` | `0` | no |
| irsa_service_accounts | Service accounts meant to be used with IRSA | ```list(object({ name = string, namespace = string, role_arn = string }))``` | `[]` | no |
| k8s_namespaces | This variable will define the namespaces to be created and then used by k8s cluster to make the role binding. Remember that `default` namespace is already set. | `list(string)` | n/a | yes |
| k8s_version | Desired Kubernetes master version. If you do not specify a value, the latest available version is used. | `string` | `""` | no |
| keypair_name | The name of an existing key pair to access the K8S workers via SSH | `string` | `""` | no |
| lb_target_group | The App LB target group ARN we want this AutoScaling Group belongs to | `string` | `""` | no |
| lint | Run the helm chart linter during the plan | `bool` | `false` | no |
| map_roles | A list of maps with the roles allowed to access EKS | ```list(object( { role_arn = string username = string group = string }))``` | n/a | yes |
| map_users | A list of maps with the IAM users allowed to access EKS | ```list(object( { user_arn = string username = string group = string }))``` | `[]` | no |
| master_role_arn | ARN of the master role | `string` | `""` | no |
| ng_role_arn | ARN of the node group role | `string` | `""` | no |
| node_groups | A list of maps with the configuration for each node group | ```list(object( { name = string scaling_config_desired_size = number scaling_config_max_size = number scaling_config_min_size = number disk_size = number instance_types = list(string) release_version = string k8s_version = string capacity_type = string ec2_pricing_model = string }))``` | n/a | yes |
| oidc_tags | A map of tags to describe the OIDC | `map(string)` | `{}` | no |
| oidc_thumbprint_list | A list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s). | `list(string)` | `[]` | no |
| priority_classes | List of all the priority classes needed to assure system stability | ```list(object( { name = string value = number description = string } ))``` | n/a | yes |
| private_subnets_ids | The IDs of at least two private subnets to deploy the K8S workers in | `list(string)` | n/a | yes |
| public_subnets_ids | The IDs of at least two public subnets for the K8S control plane ENIs | `list(string)` | n/a | yes |
| security_groups_tags | A map of tags needed to describe the Security groups | `map(string)` | `{}` | no |
| timeout | Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks) | `number` | `300` | no |
| vpc_cidr | The CIDR range used in the VPC | `list(string)` | n/a | yes |
| vpc_id | The ID of the VPC where we are deploying the EKS cluster | `string` | n/a | yes |
| wait | Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as timeout | `bool` | `true` | no |
| workers_instance_type | The instance type for the K8S workers | `string` | n/a | yes |
| workers_role_arn | ARN of the workers role | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_ca | Shows nested attribute containing certificate-authority-data for your cluster |
| cluster_endpoint | Shows the endpoint for your Kubernetes API server |
| cluster_name | The name of the EKS cluster |
| enrypted_ami_id | Shows the encrypted eks ami Id |
| oidc_arn | Openid connect provider ARN |
| workers_security_group_id | Shows the ID of the security group |
