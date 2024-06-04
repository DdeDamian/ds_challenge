## Generic code for role creation
resource "aws_iam_role" "this" {
  for_each = {
    for key in var.roles : key.role_name => key
    if key.create_role
  }

  ## Role settings
  name                 = each.value.role_name
  description          = each.value.role_description
  assume_role_policy   = each.value.assume_role_policy
  max_session_duration = each.value.max_session_duration
  tags                 = merge({ "role" = "iam" }, each.value.tags, )
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = {
    for key in local.role_policy_attachments : "${key.role_name}.${key.policy_name}" => key
  }

  role       = each.value.role_name
  policy_arn = each.value.policy_arn

  depends_on = [
    aws_iam_role.this
  ]
}
