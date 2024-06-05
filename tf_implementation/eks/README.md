# Terraform-EKS

A set of terraform scripts for installing:

- Creation of the EKS cluster
- Security Groups (Master and workers)
- Definition of templates for the implementation of workers
- Management of users using IAM users as base.
- Namespaces creation
- Cluster roles definitions
- Priority classes for specific services
- Definition of the OIDC
- Creation of ASG, node groups and launch configuration for the workers
- Creation of service accounts
- Policies and roles needed by the worker nodes
- Deployment of helm charts that you need by default, i.e cluster-autoscaler

## Requirements

| Name | Version |
|------|---------|
| terraform | 1.6.6 |
| aws | 5.52.0 |
| helm | 2.12.1 |
| kubernetes | 2.25.2 |
| template | 2.2.0 |
| tls | 4.0.5 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| cluster_addon_coredns | ./../../tf_modules/terraform-aws-eks-addons/ | n/a |
| cluster_addon_kube_proxy | ./../../tf_modules/terraform-aws-eks-addons/ | n/a |
| cluster_addon_vpc_cni | ./../../tf_modules/terraform-aws-eks-addons/ | n/a |
| irsa_policies | ./../../tf_modules/terraform-aws-iam-policy/ | n/a |
| irsa_roles | ./../../tf_modules/terraform-aws-iam-role/ | n/a |
| main_eks_cluster | ./../../tf_modules/terraform-aws-eks/ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| AWS_ACCESS_KEY_ID | This variable is set to avoid warnings on TFC. | `string` | `""` | no |
| AWS_DEFAULT_REGION | This variable is set to avoid warnings on TFC. | `string` | `""` | no |
| AWS_SECRET_ACCESS_KEY | This variable is set to avoid warnings on TFC. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| eks_cluster_endpoint | Shows the endpoint for your Kubernetes API server |
| eks_cluster_name | The name of the EKS main cluster |
