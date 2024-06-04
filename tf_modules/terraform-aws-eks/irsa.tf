# -------------------------------------------------------------
# AWS EKS clusters
# -------------------------------------------------------------

resource "kubernetes_service_account" "irsa" {
  for_each                        = local.irsa_service_accounts
  automount_service_account_token = true

  metadata {
    name        = each.value.name
    namespace   = each.value.namespace
    annotations = { "eks.amazonaws.com/role-arn" = each.value.role_arn }
    labels      = { "name" = each.value.name, created_using = "terraform", "role" = "iam" }
  }
}
