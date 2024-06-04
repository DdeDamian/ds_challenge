# -------------------------------------------------------------
# AWS VPC and subnets
# -------------------------------------------------------------

module "vpc" {
  source = "./../../tf_modules/terraform-aws-vpc/"

  # AWS profile settings
  providers = {
    aws = aws.environment
  }

  # Network settings
  cidr           = local.vpc_cidr[terraform.workspace]
  azs            = local.azs[terraform.workspace]
  public_subnet  = local.public_subnets_cidrs[terraform.workspace]
  private_subnet = local.private_subnets_cidrs[terraform.workspace]

  allow_inbound_traffic_publicsub = local.allow_inbound_traffic_publicsub[terraform.workspace]

  # Tagging
  general_labels = {
    Company     = "MyCompany"
    Environment = "${terraform.workspace}"
  }

  vcp_labels = {
    Name = "${terraform.workspace}-vpc"
  }

  ig_labels = {
    Name = "${terraform.workspace}-ig"
  }

  nat_eip_labels = {
    Name = "${terraform.workspace}-nat-eip"
  }

  nat_gateway_labels = {
    Name = "${terraform.workspace}-nat-gw"
  }

  public_subnet_label = {
    Name = "${terraform.workspace}-public-subnet"
  }

  private_subnet_label = {
    Name = "${terraform.workspace}-private-subnet"
  }

  public_routes_label = {
    Name = "${terraform.workspace}-public-route"
  }

  private_routes_label = {
    Name = "${terraform.workspace}-private-route"
  }

  public_nacl_label = {
    Name = "${terraform.workspace}-public-nacl"
  }

  private_nacl_label = {
    Name = "${terraform.workspace}-private-nacl"
  }

  eks_network_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  eks_private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}
