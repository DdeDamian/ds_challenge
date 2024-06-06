# Terraform module for Route53 records creation

Terraform module which creates an AWS Route53 subdomain. You can allow it to be delegated and define the name, domain, etc.

## Usage

This module specifically allows for the creation of the following resources:

- aws_route53_record

### Example

```hcl
# For example we can create a CNAME record
module "readreplica_cname" {
  source    = "./tf_modules/terraform-aws-route53-record"

  # AWS provider settings
  providers = {
    "aws" = "aws.environment"
  }

  create  = true
  zone_id = "Z1W1OFPZSD5RR2"
  name    = "test"
  type    = "CNAME"
  ttl     = "300"
  records = ["database.cjicivp3c4i8.us-east-1.rds.amazonaws.com"]
}

# Another example creating an A record
module "readreplica_alias" {
  source    = "./tf_modules/terraform-aws-route53-record"

  # AWS provider settings
  providers = {
    "aws" = "aws.environment"
  }

  create  = true
  zone_id = "Z1W1OFPZSD5RR2"
  name    = "test"
  type    = "A"
    
  alias = {
    "database.cjicivp3c4i8.us-east-1.rds.amazonaws.com" = {
      zone_id = "Z215JYRZR1TB5678"
    }
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
| [aws_route53_record.record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alias | A map of alias defenitions | ```map(object({ zone_id = string }))``` | n/a | yes |
| create | Boolean that controls if whether to create a cname or not | `bool` | `false` | no |
| name | The name of the record. | `string` | n/a | yes |
| records | A string list of records. | `list(string)` | n/a | yes |
| ttl | The TTL of the record set. | `number` | `300` | no |
| type | The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT. | `string` | n/a | yes |
| zone_id | The ID of the hosted zone to contain this record. | `string` | n/a | yes |

## Outputs

No outputs.
