resource "oci_identity_dynamic_group" "oci-id-dynamic-group" {
  compartment_id = data.oci_identity_compartment.oci-root-compartment.id
  name           = "${var.prefix}-id-dynamic-group-${random_string.oci-random.result}"
  description    = "Identity Dynamic Group for Compute Instance in Compartment"
  matching_rule  = "All {instance.compartment.id = '${oci_identity_compartment.oci-compartment.id}'}"
}

resource "oci_identity_policy" "oci-id-instance-policy" {
  compartment_id = data.oci_identity_compartment.oci-root-compartment.id
  name           = "${var.prefix}-instance-policy"
  description    = "Identity Policy for instance to use object storage encryption"
  statements     = ["Allow dynamic-group ${oci_identity_dynamic_group.oci-id-dynamic-group.name} to use secret-family in compartment id ${oci_identity_compartment.oci-compartment.id} where target.vault.id='${oci_kms_vault.oci-kms-vault.id}'", "Allow dynamic-group ${oci_identity_dynamic_group.oci-id-dynamic-group.name} to use vaults in compartment id ${oci_identity_compartment.oci-compartment.id} where target.vault.id='${oci_kms_vault.oci-kms-vault.id}'", "Allow dynamic-group ${oci_identity_dynamic_group.oci-id-dynamic-group.name} to use keys in compartment id ${oci_identity_compartment.oci-compartment.id} where target.vault.id='${oci_kms_vault.oci-kms-vault.id}'", "Allow dynamic-group ${oci_identity_dynamic_group.oci-id-dynamic-group.name} to manage object-family in compartment id ${oci_identity_compartment.oci-compartment.id} where target.bucket.name='${var.prefix}-bucket'", "Allow dynamic-group ${oci_identity_dynamic_group.oci-id-dynamic-group.name} to read virtual-network-family in compartment id ${oci_identity_compartment.oci-compartment.id}"]
}

resource "oci_identity_policy" "oci-id-disk-policy" {
  compartment_id = data.oci_identity_compartment.oci-root-compartment.id
  name           = "${var.prefix}-id-disk-policy"
  description    = "Identity Policy for disk encryption"
  statements     = ["Allow service blockstorage to use keys in compartment id ${oci_identity_compartment.oci-compartment.id} where target.vault.id='${oci_kms_vault.oci-kms-vault.id}'"]
}

resource "oci_identity_policy" "oci-id-storageobject-policy" {
  compartment_id = data.oci_identity_compartment.oci-root-compartment.id
  name           = "${var.prefix}-id-storageobject-policy"
  description    = "Identity Policy for objectstorage service"
  statements     = ["Allow service objectstorage-${local.oci_region} to use keys in compartment id ${oci_identity_compartment.oci-compartment.id} where target.vault.id='${oci_kms_vault.oci-kms-vault.id}'", "Allow service objectstorage-${local.oci_region} to manage object-family in compartment id ${oci_identity_compartment.oci-compartment.id}"]
}

# resource "oci_identity_group" "oci-bucket-group" {
#   compartment_id = data.oci_identity_compartment.oci-root-compartment.id
#   description    = "OCI bucket group"
#   name           = "${var.prefix}-bucket-group-${random_string.oci-random.result}"
# }

# resource "oci_identity_user" "oci-bucket-user" {
#   compartment_id = data.oci_identity_compartment.oci-root-compartment.id
#   description    = "OCI bucket user"
#   name           = "${var.prefix}-user-${random_string.oci-random.result}"
#   email          = "${var.prefix}@${var.prefix}${random_string.oci-random.result}.email"
# }

# resource "oci_identity_user_group_membership" "oci-bucket-group-membership" {
#   group_id = oci_identity_group.oci-bucket-group.id
#   user_id  = oci_identity_user.oci-bucket-user.id
# }

# resource "oci_identity_customer_secret_key" "oci-bucker-user-key" {
#   display_name = "${var.prefix}-bucket-user-key"
#   user_id      = oci_identity_user.oci-bucket-user.id
# }

# resource "oci_identity_policy" "oci-id-bucket-policy" {
#   compartment_id = data.oci_identity_compartment.oci-root-compartment.id
#   name           = "${var.prefix}-bucket-policy"
#   description    = "Identity Policy for instance bucket user to use object storage encryption for data bucket"
#   statements     = ["Allow group ${oci_identity_group.oci-bucket-group.name} to manage object-family in compartment id ${oci_identity_compartment.oci-compartment.id} where any {target.bucket.name='${var.prefix}-bucket',target.bucket.name='${var.prefix}-bucket-data'}"]
# }
