variable "general_labels" {
  description = "Common labels for resources"
  type        = map(string)
}

#################
## VPC Variables
#################

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "instance_tenancy" {
  description = "Allowed tenancy of instances launched into the selected VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "vcp_labels" {
  description = "Labels to apply to the VPC"
  type        = map(string)
}

variable "ig_labels" {
  description = "Labels to apply to the internet gateway"
  type        = map(string)
}

variable "enable_nat_gw" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

variable "nat_eip_labels" {
  description = "Labels to apply to the NAT EIP"
  type        = map(string)
}

variable "nat_gateway_labels" {
  description = "Labels to apply to the NAT Gateway"
  type        = map(string)
}

variable "public_subnet" {
  description = "A list of public subnets inside the VPC (Note: use CIDRs)"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  type        = bool
  default     = false
}

variable "public_subnet_label" {
  description = "Labels to apply to the public subnets"
  type        = map(string)
}

variable "private_subnet" {
  description = "A list of private subnets inside the VPC (Note: use CIDRs)"
  type        = list(string)
  default     = []
}

variable "private_subnet_label" {
  description = "Labels to apply to the private subnets"
  type        = map(string)
}

variable "public_routes_label" {
  description = "Labels to apply to the public routes"
  type        = map(string)
}

variable "private_routes_label" {
  description = "Labels to apply to the private routes"
  type        = map(string)
}

variable "single_nat_gw" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}

######################
## Security Variables
######################
variable "public_nacl_label" {
  description = "Labels to apply to the public network ACL"
  type        = map(string)
}

variable "private_nacl_label" {
  description = "Labels to apply to the private network ACL"
  type        = map(string)
}



#################
# Security rules
#################

variable "allow_inbound_traffic_default_publicsub" {
  description = "A list of maps of inbound traffic allowed by default for public subnets"
  type = list(object(
    {
      protocol  = string
      from_port = number
      to_port   = number
      source    = string
    }
  ))

  default = [
    {
      # ephemeral tcp ports (allow return traffic for software updates to work)
      protocol  = "tcp"
      from_port = 1024
      to_port   = 65535
      source    = "0.0.0.0/0"
    },
    {
      # ephemeral udp ports (allow return traffic for software updates to work)
      protocol  = "udp"
      from_port = 1024
      to_port   = 65535
      source    = "0.0.0.0/0"
    },
    {
      # HTTPS
      protocol  = "tcp"
      from_port = 443
      to_port   = 443
      source    = "0.0.0.0/0"
    },
  ]
}

variable "allow_inbound_traffic_publicsub" {
  description = "The inbound traffic the customer needs to allow for public subnets"
  type = list(object(
    {
      protocol  = string
      from_port = number
      to_port   = number
      source    = string
    }
  ))
  default = []
}

variable "allow_inbound_traffic_default_privatesub" {
  description = "A list of maps of inbound traffic allowed by default for private subnets"
  type = list(object(
    {
      protocol  = string
      from_port = number
      to_port   = number
      source    = string
    }
  ))

  default = [
    {
      # ephemeral tcp ports (allow return traffic for software updates to work)
      protocol  = "tcp"
      from_port = 1024
      to_port   = 65535
      source    = "0.0.0.0/0"
    },
    {
      # ephemeral udp ports (allow return traffic for software updates to work)
      protocol  = "udp"
      from_port = 1024
      to_port   = 65535
      source    = "0.0.0.0/0"
    },
  ]
}

variable "allow_inbound_traffic_privatesub" {
  description = "The ingress traffic the customer needs to allow for private subnets"
  type        = list(string)
  default     = []
}

#################
# Tags
#################

variable "general_namespace" {
  description = "Namespace to use on the labeling."
  type        = string
  default     = "Billomat"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "eks_network_tags" {
  description = "A map of tags needed by EKS to identify the VPC and subnets"
  type        = map(string)
  default     = {}
}

variable "eks_private_subnet_tags" {
  description = "A map of tags needed by EKS to identify private subnets for internal LBs"
  type        = map(string)
  default     = {}
}
