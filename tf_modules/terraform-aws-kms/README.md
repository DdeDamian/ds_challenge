# AWS KMS Terraform module

Terraform module which creates KMS keys.

- [Amazon KMS ](https://aws.amazon.com/es/kms/)

This module allows you to create KMS key(s). Enabling or not the key, defining aliases, etc.

## Usage

You'll need to have your AWS_PROFILE loaded up. Once you do, the module will ask you for the variables that you'll want to set as seen below (e.g.):

### Example

```hcl
module "kms" {
  source    = "./tf_modules/terraform-aws-kms"

  # AWS provider settings
  providers = {
    "aws" = "aws.environment"
  }

  account_id     = "631169009083"
  create_kms_key = "true"
  enable_key     = "true"
  key_alias      = "test_key"
  environment    = "staging"
  tags           = []
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
| [aws_kms_alias.kms_key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create_kms_key | This variable will define if we crete the resource or not | `bool` | n/a | yes |
| description | The description of the key as viewed in AWS console. | `string` | n/a | yes |
| enable_key | Specifies whether the key is enabled. | `bool` | `true` | no |
| key_alias | The display name of the alias. | `string` | n/a | yes |
| policy | A valid policy JSON document. | `string` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| usage | Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY. | `string` | `"ENCRYPT_DECRYPT"` | no |

## Outputs

| Name | Description |
|------|-------------|
| kms_key_alias_arn | Shows the alias Amazon Resource Name (ARN) of the key. |
| kms_key_arn | Shows the Amazon Resource Name (ARN) of the key. |
| kms_key_id | Shows the globally unique identifier for the key. |
