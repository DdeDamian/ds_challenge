# -------------------------------------------------------------
# Policy variables
# -------------------------------------------------------------

variable "policies" {
  description = "Map of policies to be created"
  type = map(object({
    create_policy    = bool
    name             = string
    path             = string
    description      = string
    policy           = string
    tags             = map(string)
    policy_variables = map(string)
  }))
  default = {}
}
