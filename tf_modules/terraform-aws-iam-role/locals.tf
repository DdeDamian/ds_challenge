
locals {
  ## Flatten out a map of roles, each including a list of
  ## policies, to a list of roles and policies
  role_policy_attachments = flatten([
    for role_key, role in var.roles : [
      for policy in role.policy_arn : {
        role_name  = role.role_name
        policy_arn = policy
        ## We obtain policy name extracting it from its arn.
        ## Policy name is the alfanumeric sequence of characters
        ## that comes right after the forward slash character.
        policy_name = substr(regex("^*/[[:alnum:]]+", policy), 1, (length(regex("^*/[[:alnum:]]+", policy)) - 1))
      }
      if role.create_role
    ]
  ])
}
