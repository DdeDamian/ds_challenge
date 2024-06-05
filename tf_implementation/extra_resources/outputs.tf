# -------------------------------------------------------------
# KMS outputs
# -------------------------------------------------------------
output "sops_key_arn" {
  description = "ARN of the KMS key for sops resources."
  value       = module.sops_kms_key.kms_key_arn
}
