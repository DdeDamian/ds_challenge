# -------------------------------------------------------------
# IAM Policy
# -------------------------------------------------------------

resource "aws_iam_policy" "this" {
  for_each = {
    for p in var.policies : p.name => p
    if p.create_policy
  }

  name        = each.value.name
  path        = each.value.path
  description = each.value.description
  policy      = templatefile(each.value.policy, try(each.value.policy_variables, {}))
  tags        = merge({ "role" = "iam" }, each.value.tags)
}
