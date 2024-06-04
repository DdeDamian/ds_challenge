locals {
  # -------------------------------------------------------------
  # AWS account settings
  # -------------------------------------------------------------
  env_account_id = {
    development = 891377286140
  }

  provider_region = {
    development = "eu-central-1"
  }

  # -------------------------------------------------------------
  # VPC settings
  # -------------------------------------------------------------
  vpc_cidr = {
    development = "172.4.0.0/16"
  }

  azs = {
    development = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  }

  public_subnets_cidrs = {
    development = ["172.4.2.0/24", "172.4.4.0/24", "172.4.6.0/24"]
  }

  private_subnets_cidrs = {
    development = ["172.4.3.0/24", "172.4.5.0/24", "172.4.7.0/24"]
  }

  allow_inbound_traffic_publicsub = {
    development = [
      {
        protocol  = "tcp"
        from_port = 80
        to_port   = 80
        source    = "0.0.0.0/0"
      },
      {
        protocol  = "tcp"
        from_port = 22
        to_port   = 22
        source    = "0.0.0.0/0"
      },
      {
        protocol  = "tcp"
        from_port = 8080
        to_port   = 8080
        source    = "0.0.0.0/0"
      },
      {
        protocol  = "tcp"
        from_port = 8001
        to_port   = 8001
        source    = "0.0.0.0/0"
      },
    ]
  }

  # -------------------------------------------------------------
  # EKS settings
  # -------------------------------------------------------------
  cluster_name = "${terraform.workspace}-eks-cluster"

}
