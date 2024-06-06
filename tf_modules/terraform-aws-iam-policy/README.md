# AWS IAM Policy creation Terraform module

Terraform module which creates IAM Policies

- [Amazon IAM policies](https://aws.amazon.com/iam/)

## Usage

You'll need to have your AWS_PROFILE loaded up. Once you do, the module will ask you for the variables that you'll want to set as seen below (e.g.):

### Example

```hcl
module "policies" {
  source    = "./tf_modules/terraform-aws-iam-policy"

  # AWS provider settings
  providers = {
    "aws" = "aws.identity"
  }

  # Custom policies
  policies = {
    "CustomPolicy" = {
       create_policy = true
       name          = "CustomPolicy"
       path          = "/"
       description   = "This is a custom policy"
       policy        = "${path.module}/policies/custom-policy.json"
       tags          = {"environment" = local.terraform_cloud_workspace}
       template_variables = {"aws_identity_acct" = "979895001312"}
    },

  }
}
```

## Requirements

| Name | Version |
|------|---------|
| aws | >= 5.52.0 |
| required_version | >= 1.6.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| policies | Map of policies to be created | ```map(object({ create_policy = bool name = string path = string description = string policy = string tags = map(string) policy_variables = map(string) }))``` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| policies_arn | Map of policies' name and arn |
