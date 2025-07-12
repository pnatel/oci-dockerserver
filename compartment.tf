data "oci_identity_compartment" "oci-root-compartment" {
  id = var.tenancy_ocid
}

resource "oci_identity_compartment" "oci-compartment" {
  compartment_id = data.oci_identity_compartment.oci-root-compartment.id
  description    = "${var.prefix}-compartment"
  name           = "${var.prefix}-compartment"
}

resource "random_string" "oci-random" {
  length  = 5
  upper   = false
  special = false
}
