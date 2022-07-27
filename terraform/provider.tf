terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.85.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.3.1"
    }
  }
}
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
provider "rke" {
  debug = true
}