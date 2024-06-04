# -------------------------------------------------------------
# Variables
# -------------------------------------------------------------

variable "cluster_name" {
  description = "Name of the EKS Cluster."
  type        = string
}

variable "enabled" {
  description = "Determines if the resources will be created or not."
  type        = string
  default     = true
}

variable "addon_name" {
  description = "Name of the EKS add-on. The name must match one of the names returned by list-addon(https://docs.aws.amazon.com/cli/latest/reference/eks/list-addons.html)."
  type        = string
}

variable "addon_version" {
  description = " The version of the EKS add-on. The version must match one of the versions returned by describe-addon-versions.(https://docs.aws.amazon.com/cli/latest/reference/eks/describe-addon-versions.html)"
  type        = string
}

variable "addon_conflict" {
  description = "Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE and OVERWRITE."
  type        = string
  default     = "OVERWRITE"
}

variable "addon_tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}
