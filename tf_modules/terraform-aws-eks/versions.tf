terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws        = ">= 5.52.0"
    helm       = ">= 2.12.0"
    kubernetes = ">= 2.25.0"
    template   = ">= 2.2.0"
    tls        = ">= 4.0.0"
  }
}
