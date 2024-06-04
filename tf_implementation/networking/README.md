# Terraform-networking

A set of terraform scripts for installing:

- VPC
- Subnets
- Internet gateway
- NAT gateway
- Route tables
- Security groups
- nACL

## Requirements

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
| vpc | ./../../tf_modules/terraform-aws-vpc/ | n/a |

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
| private_subnets | List of IDs of private subnets |
| public_subnets | List of IDs of public subnets |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_id | The ID of the VPC |
| vpc_nat_public_ip | The public IP of NATgw's vpc |
