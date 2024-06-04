# -------------------------------------------------------------
# Networking remote State
# -------------------------------------------------------------

# If we use remote state for networking for example using terraform cloud, 
# we can retrieve the state using the following code:

# data "terraform_remote_state" "networking" {
#   backend = "remote"

#   config = {
#     organization = "xxx"
#     workspaces = {
#       name = "iac-networking-${terraform.workspace}"
#     }
#   }
# }
