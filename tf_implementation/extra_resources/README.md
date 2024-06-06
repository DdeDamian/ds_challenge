# Extra resources

A set of terraform scripts for installing:

- KMS keys

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.6.6 |
| aws | ~> 5.52.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| sops_kms_key | ./../../tf_modules/terraform-aws-kms/ | n/a |

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
| sops_key_arn | ARN of the KMS key for sops resources. |
