AWS IAM Roles creation Terraform module
========================

Terraform module which creates IAM roles and its policy attachments.

Usage
-----
This module specifically allows for the creation of the following resources:

- aws_iam_role
- aws_iam_role_policy_attachment

## Usage example

```
module "my_test_role" {
  source    = "./tf_modules/terraform-aws-iam-role"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  roles = {
    "MyTestRole" = {
       create_role          = true
       role_name            = "MyTestRole"
       assume_role_policy   = aws_iam_policy_document.some_assume_role_policy.json
       max_session_duration = 3600
       role_description     = "This role is a test role"
       policy_arn           = [arn:aws:iam::5555555555:policy/SomePolicy, arn:aws:iam::5555555555:policy/OtherPolicy]
       tags                 = {environment = "${local.terraform_cloud_workspace}"}
    },
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.6 |
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
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| principal_arns | n/a | `list(string)` | `[]` | no |
| roles | Map of roles to be created, including policies to be attached | ```map(object({ create_role = bool role_name = string role_description = string assume_role_policy = string max_session_duration = number policy_arn = list(string) tags = map(string) }))``` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| roles_arn | Map of roles' name and arn |
