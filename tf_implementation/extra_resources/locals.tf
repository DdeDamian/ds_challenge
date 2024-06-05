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
  # SOPS KMS key
  # -------------------------------------------------------------
  create_sops_key = {
    development = true
  }
  enable_sops_key = {
    development = true
  }
  sops_key_alias = {
    development = "sops_key"
  }
  sops_key_tags = {
    development = {
      Environment = "development"
    }
  }
}
