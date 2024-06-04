# --------------------------------------------------------------------
# EKS Addons resources
# --------------------------------------------------------------------
resource "aws_eks_addon" "cluster_addon" {

  count                       = var.enabled ? 1 : 0
  cluster_name                = var.cluster_name
  addon_name                  = var.addon_name
  addon_version               = var.addon_version
  resolve_conflicts_on_create = var.addon_conflict
  tags                        = var.addon_tags
}
