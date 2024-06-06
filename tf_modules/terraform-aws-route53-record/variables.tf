variable "create" {
  description = "Boolean that controls if whether to create a cname or not"
  type        = bool
  default     = false
}

variable "zone_id" {
  description = "The ID of the hosted zone to contain this record."
  type        = string
}

variable "name" {
  description = "The name of the record."
  type        = string
}

variable "type" {
  description = "The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT."
  type        = string
}

variable "ttl" {
  description = "The TTL of the record set."
  type        = number
  default     = 300
}

variable "records" {
  description = "A string list of records."
  type        = list(string)
}

variable "alias" {
  description = "A map of alias defenitions"
  type        = map(object({
    zone_id = string
  }))
}
