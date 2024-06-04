output "policies_arn" {
  description = "Map of policies' name and arn"
  value = {
    for p in aws_iam_policy.this :
    p.name => p.arn
  }
}
