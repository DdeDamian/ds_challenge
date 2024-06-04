terraform {
  required_providers {
    required_version = ">= 1.6.0"
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.52.0"
    }
  }
}
