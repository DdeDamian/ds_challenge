# Shows the Amazon Resource Name (ARN) of the key.
output "kms_key_arn" {
  value = join("", aws_kms_key.kms_key.*.arn)
}

# Shows the globally unique identifier for the key.
output "kms_key_id" {
  value = join("", aws_kms_key.kms_key.*.key_id)
}

# Shows the alias Amazon Resource Name (ARN) of the key.
output "kms_key_alias_arn" {
  value = join("", aws_kms_alias.kms_key_alias.*.arn)
}
