output "roles_arn" {
  description = "Map of roles' name and arn"
  value = { for role in aws_iam_role.this :
    role.name => role.arn
  }
}
