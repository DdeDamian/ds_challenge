resource "aws_kms_key" "kms_key" {
  count       = var.create_kms_key ? 1 : 0
  description = var.description
  key_usage   = var.usage
  policy      = var.policy
  is_enabled  = var.enable_key
  tags        = var.tags
}

resource "aws_kms_alias" "kms_key_alias" {
  count         = var.create_kms_key ? 1 : 0
  name          = "alias/${var.key_alias}"
  target_key_id = aws_kms_key.kms_key[0].key_id
}
