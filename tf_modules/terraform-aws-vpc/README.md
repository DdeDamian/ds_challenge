AWS VPC Terraform module
========================

Terraform module which creates VPC resources on AWS.

These types of resources are supported:

* [VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)
* [Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
* [Route](https://www.terraform.io/docs/providers/aws/r/route.html)
* [Route table](https://www.terraform.io/docs/providers/aws/r/route_table.html)
* [Internet Gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)
* [NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html)
* [ACL support](https://www.terraform.io/docs/providers/aws/r/network_acl.html)

This module creates the VPC along side the required resources to make the VPN work.
Currently it's setup to create an Internet Gateway and a NAT gateway. NAT has elasticIPs assigned. There's one public subnet, one private subnet and one DB subnet, each with it's own route table.

Usage
-----
You'll need to have your AWS_PROFILE loaded up. Once you do, the module will ask you for the variables that you'll want to set as seen below (e.g.):

### Example VPC

```hcl
module "vpc" {
  source  = "app.terraform.io/ddedamian/vpc/aws"
  version = "1.0.0"

  # AWS profile settings
  providers = {
    "aws" = "aws.environment"
  }

  # Network settings
  cidr            = "172.16.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnet   = ["172.16.6.0/24","172.16.7.0/24","172.16.8.0/24"]
  private_subnet  = ["172.16.0.0/23", "172.16.2.0/23","172.16.4.0/23"]
  database_subnet = ["172.16.9.0/24","172.16.10.0/24","172.16.11.0/24"]
  environment = "stage"
  general_namespace = "myComp Inc."

  tags = {
    Company = "myComp Inc."
  }

  eks_network_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  eks_private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.6.0 |
| aws | ~> 5.52.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 5.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_rule.allow_inbound_traffic_privatesub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.allow_inbound_traffic_publicsub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.allow_outbound_traffic_privatesub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.allow_outbound_traffic_publicsub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.allow_private_inbound_vpc_traffic_privatesub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_network_acl_rule.allow_private_inbound_vpc_traffic_publicsub](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.nat_gw_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.private_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public_routes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow_inbound_traffic_default_privatesub | A list of maps of inbound traffic allowed by default for private subnets | ```list(object( { protocol = string from_port = number to_port = number source = string } ))``` | ```[ { "from_port": 1024, "protocol": "tcp", "source": "0.0.0.0/0", "to_port": 65535 }, { "from_port": 1024, "protocol": "udp", "source": "0.0.0.0/0", "to_port": 65535 } ]``` | no |
| allow_inbound_traffic_default_publicsub | A list of maps of inbound traffic allowed by default for public subnets | ```list(object( { protocol = string from_port = number to_port = number source = string } ))``` | ```[ { "from_port": 1024, "protocol": "tcp", "source": "0.0.0.0/0", "to_port": 65535 }, { "from_port": 1024, "protocol": "udp", "source": "0.0.0.0/0", "to_port": 65535 }, { "from_port": 443, "protocol": "tcp", "source": "0.0.0.0/0", "to_port": 443 } ]``` | no |
| allow_inbound_traffic_privatesub | The ingress traffic the customer needs to allow for private subnets | `list(string)` | `[]` | no |
| allow_inbound_traffic_publicsub | The inbound traffic the customer needs to allow for public subnets | ```list(object( { protocol = string from_port = number to_port = number source = string } ))``` | `[]` | no |
| azs | A list of availability zones in the region | `list(string)` | `[]` | no |
| cidr | The CIDR block for the VPC | `string` | n/a | yes |
| eks_network_tags | A map of tags needed by EKS to identify the VPC and subnets | `map(string)` | `{}` | no |
| eks_private_subnet_tags | A map of tags needed by EKS to identify private subnets for internal LBs | `map(string)` | `{}` | no |
| enable_dns_hostnames | Should be true to enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| enable_nat_gw | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `true` | no |
| environment | The environment where you want to create the VPC and depending resources | `string` | n/a | yes |
| general_labels | Common labels for resources | `map(string)` | n/a | yes |
| general_namespace | Namespace to use on the labeling. | `string` | `"Billomat"` | no |
| ig_labels | Labels to apply to the internet gateway | `map(string)` | n/a | yes |
| instance_tenancy | Allowed tenancy of instances launched into the selected VPC | `string` | `"default"` | no |
| map_public_ip_on_launch | Should be false if you do not want to auto-assign public IP on launch | `bool` | `false` | no |
| nat_eip_labels | Labels to apply to the NAT EIP | `map(string)` | n/a | yes |
| nat_gateway_labels | Labels to apply to the NAT Gateway | `map(string)` | n/a | yes |
| private_nacl_label | Labels to apply to the private network ACL | `map(string)` | n/a | yes |
| private_routes_label | Labels to apply to the private routes | `map(string)` | n/a | yes |
| private_subnet | A list of private subnets inside the VPC (Note: use CIDRs) | `list(string)` | `[]` | no |
| private_subnet_label | Labels to apply to the private subnets | `map(string)` | n/a | yes |
| public_nacl_label | Labels to apply to the public network ACL | `map(string)` | n/a | yes |
| public_routes_label | Labels to apply to the public routes | `map(string)` | n/a | yes |
| public_subnet | A list of public subnets inside the VPC (Note: use CIDRs) | `list(string)` | `[]` | no |
| public_subnet_label | Labels to apply to the public subnets | `map(string)` | n/a | yes |
| single_nat_gw | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `true` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vcp_labels | Labels to apply to the VPC | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| database_subnets | List of IDs for DB subnets |
| database_subnets_azs | List of the AZ for the subnet |
| default_security_group_id | The ID of the security group created by default on VPC creation |
| igw_id | The ID of the Internet Gateway |
| nat_gw_ids | List of NAT Gateway IDs |
| nat_ids | List of allocation ID of Elastic IPs created for AWS NAT Gateway |
| nat_public_ips | List of public Elastic IPs created for AWS NAT Gateway |
| private_route_table_ids | List of IDs of private route tables |
| private_subnets | List of IDs of private subnets |
| private_subnets_cidr_blocks | List of cidr_blocks of private subnets |
| public_route_table_ids | List of IDs of public route tables |
| public_subnets | List of IDs of public subnets |
| public_subnets_cidr_blocks | List of cidr_blocks of public subnets |
| vpc_cidr_block | The CIDR block of the VPC |
| vpc_id | The ID of the VPC |
