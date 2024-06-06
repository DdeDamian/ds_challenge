variable "create_kms_key" {
  description = "This variable will define if we crete the resource or not"
  type        = bool
}

variable "enable_key" {
  description = "Specifies whether the key is enabled."
  type        = bool
  default     = true
}

variable "key_alias" {
  description = "The display name of the alias."
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "policy" {
  description = "A valid policy JSON document."
  type        = string
}

variable "description" {
  description = "The description of the key as viewed in AWS console."
  type        = string
}

variable "usage" {
  description = "Specifies the intended use of the key. Valid values: ENCRYPT_DECRYPT or SIGN_VERIFY."
  default     = "ENCRYPT_DECRYPT"
  type        = string
}
