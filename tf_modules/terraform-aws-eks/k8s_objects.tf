# --------------------------------------------------------------------
# aws-auth ConfigMap
# --------------------------------------------------------------------

## generate base template for workers
data "template_file" "worker_role_arns" {
  template = file("${path.module}/templates/worker-role.tpl")

  vars = {
    workers_role_arn = var.create_workers_role ? aws_iam_role.k8s_workers_role[0].arn : var.workers_role_arn
  }
}

## generate base template for workers in node groups
data "template_file" "node_group_worker_role_arns" {
  template = file("${path.module}/templates/node-group-worker-role.tpl")

  vars = {
    node_group_workers_role_arn = var.create_ng_role ? aws_iam_role.ng[0].arn : var.ng_role_arn
  }
}

## generate templates mapping IAM users with cluster users/groups
data "template_file" "map_users" {
  count    = length(var.map_users)
  template = file("${path.module}/templates/aws-auth_map-users.yaml.tpl")

  vars = {
    user_arn = lookup(var.map_users[count.index], "user_arn")
    username = lookup(var.map_users[count.index], "username")
    group    = lookup(var.map_users[count.index], "group")
  }
}

## generate templates mapping IAM users with cluster users/roles
data "template_file" "map_roles" {
  count    = length(var.map_roles)
  template = file("${path.module}/templates/aws-auth_map-roles.yaml.tpl")

  vars = {
    role_arn = lookup(element(var.map_roles, count.index), "role_arn")
    username = lookup(var.map_roles[count.index], "username")
    group    = lookup(var.map_roles[count.index], "group")
  }
}

## deploy the aws-auth ConfigMap
resource "kubernetes_config_map" "aws_auth_cm" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = join("", data.template_file.map_roles.*.rendered, data.template_file.worker_role_arns.*.rendered, data.template_file.node_group_worker_role_arns.*.rendered)
    mapUsers = join("", data.template_file.map_users.*.rendered)
  }

  depends_on = [aws_eks_cluster.masters]
}

# --------------------------------------------------------------------
# Service Accounts & Roles
# --------------------------------------------------------------------
resource "kubernetes_namespace" "environment_namespaces" {
  count = length(var.k8s_namespaces)

  metadata {
    name = var.k8s_namespaces[count.index]
  }

  depends_on = [aws_eks_cluster.masters]
}

# --------------------------------------------------------------------
# RBAC custom roles
# --------------------------------------------------------------------

## ClusterRole allowing read-only to nodes and top resources
resource "kubernetes_cluster_role" "ro_nodes" {
  metadata {
    name = "read-only-nodes"
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "namespaces", "pods", "pods/log", "pods/status", "configmaps", "services"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["metrics.k8s.io"]
    resources  = ["top"]
    verbs      = ["node", "pod"]
  }
}

## Bind the ClusterRole 'edit' and 'read-only' to a group named 'PowerUserGroup'
## Scoped to the entire cluster.
resource "kubernetes_cluster_role_binding" "power_user" {
  metadata {
    name = "power-user-global"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    kind      = "Group"
    name      = "PowerUserGroup"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role_binding" "ro_nodes" {
  metadata {
    name = "power-user-ro-nodes"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "read-only-nodes"
  }

  subject {
    kind      = "Group"
    name      = "PowerUserGroup"
    api_group = "rbac.authorization.k8s.io"
  }
}

## Bind the Role 'edit' to a group named 'ScopedPowerUserGroup'
## Role edit scoped to a list of namespaces + the default one.
resource "kubernetes_role_binding" "scoped_power_user" {
  count = length(local.k8s_all_namespaces)

  metadata {
    name      = "power-user"
    namespace = local.k8s_all_namespaces[count.index]
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    kind      = "Group"
    name      = "ScopedPowerUserGroup"
    api_group = "rbac.authorization.k8s.io"
    namespace = local.k8s_all_namespaces[count.index]
  }

  depends_on = [kubernetes_namespace.environment_namespaces]
}

resource "kubernetes_priority_class" "k8s_priority_classes" {
  for_each = length(local.priority_classes) > 0 ? local.priority_classes : {}

  metadata {
    name = each.value.name
  }

  value       = each.value.value
  description = each.value.description
}

