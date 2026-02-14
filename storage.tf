data "oci_objectstorage_namespace" "oci-bucket-namespace" {
  compartment_id = oci_identity_compartment.oci-compartment.id
}

resource "oci_objectstorage_bucket" "oci-bucket" {
  compartment_id = oci_identity_compartment.oci-compartment.id
  name           = "${var.prefix}-bucket"
  namespace      = data.oci_objectstorage_namespace.oci-bucket-namespace.namespace
  kms_key_id     = oci_kms_key.oci-kms-storage-key.id
  access_type    = "NoPublicAccess"
  storage_tier   = "Standard"
  versioning     = "Disabled"
  lifecycle {
    prevent_destroy = true
  }
}

resource "oci_objectstorage_bucket" "oci-bucket-data" {
  compartment_id = oci_identity_compartment.oci-compartment.id
  name           = "${var.prefix}-bucket-data"
  namespace      = data.oci_objectstorage_namespace.oci-bucket-namespace.namespace
  kms_key_id     = oci_kms_key.oci-kms-storage-key.id
  access_type    = "NoPublicAccess"
  storage_tier   = "Standard"
  versioning     = "Disabled"
  lifecycle {
    prevent_destroy = true
  }
}
