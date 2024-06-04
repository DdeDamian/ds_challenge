AWS EKS Addons Terraform module
=======================

Terraform module which creates AWS EKS Kubernetes addonsin a given cluster.

* [Amazon EKS ](https://aws.amazon.com/eks/)
* [Amazon EKS Addons](https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html)

Usage
-----
You'll need to have your AWS_PROFILE loaded up. Once you do, the module will ask you for the variables that you'll want to set as seen below (e.g.):


## Usage example

```hcl
module "cluster_addon_kube_proxy" {
  source    = "./tf_modules/terraform-aws-eks-addons"

  addon_name     = "kube_proxy"
  cluster_name   = "test-cluster"
  addon_version  = "v1.19.6-eksbuild.2"
  addon_conflict = "OVERWRITE"
  addon_tags     = {
    Name    = "Kube Proxy"
    Version = "v1.19.6-eksbuild.2"
  }

}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6.0 |
| aws | >= 5.52.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.cluster_addon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| addon_conflict | Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE and OVERWRITE. | `string` | `"OVERWRITE"` | no |
| addon_name | Name of the EKS add-on. The name must match one of the names returned by list-addon(https://docs.aws.amazon.com/cli/latest/reference/eks/list-addons.html). | `string` | n/a | yes |
| addon_tags | Key-value map of resource tags. | `map(string)` | `{}` | no |
| addon_version | The version of the EKS add-on. The version must match one of the versions returned by describe-addon-versions.(https://docs.aws.amazon.com/cli/latest/reference/eks/describe-addon-versions.html) | `string` | n/a | yes |
| cluster_name | Name of the EKS Cluster. | `string` | n/a | yes |
| enabled | Determines if the resources will be created or not. | `string` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| addon_arn | Amazon Resource Name (ARN) of the EKS add-on. |
| addon_id | EKS Cluster name and EKS Addon name separated by a colon. |