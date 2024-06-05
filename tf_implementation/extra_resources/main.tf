# -------------------------------------------------------------
# Providers
# -------------------------------------------------------------
provider "aws" {
  alias  = "environment"
  region = local.provider_region[terraform.workspace]

  allowed_account_ids = [local.env_account_id[terraform.workspace]]

}
