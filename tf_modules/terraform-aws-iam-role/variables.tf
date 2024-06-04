## Variable for role creation
variable "roles" {
  description = "Map of roles to be created, including policies to be attached"
  default     = {}
  type = map(object({
    create_role          = bool
    role_name            = string
    role_description     = string
    assume_role_policy   = string
    max_session_duration = number
    policy_arn           = list(string)
    tags                 = map(string)
  }))
}

# -------------------------------------------------------------
# Roles variables
# -------------------------------------------------------------

variable "principal_arns" {
  type    = list(string)
  default = []
}
