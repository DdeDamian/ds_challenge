# -------------------------------------------------------------
# AWS EKS clusters
# -------------------------------------------------------------
module "irsa_policies" {
  source = "./../../tf_modules/terraform-aws-iam-policy/"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  policies = local.irsa_policies[terraform.workspace]
}

module "irsa_roles" {
  source = "./../../tf_modules/terraform-aws-iam-role/"

  # AWS provider settings
  providers = {
    aws = aws.environment
  }

  roles = local.irsa_roles[terraform.workspace]
}
