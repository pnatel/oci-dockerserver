data "oci_core_image" "oci-image" {
  image_id = var.oci_imageid
}

data "oci_identity_availability_domain" "oci-availability-domain" {
  compartment_id = oci_identity_compartment.oci-compartment.id
  ad_number      = var.oci_adnumber
}

resource "oci_core_instance" "oci-instance" {
  compartment_id       = oci_identity_compartment.oci-compartment.id
  availability_domain  = data.oci_identity_availability_domain.oci-availability-domain.name
  display_name         = "${var.prefix}-${random_string.oci-random.result}-instance"
  shape                = var.oci_instance_shape
  preserve_boot_volume = var.preserve_boot_volume
  lifecycle {
    # prevent_destroy = true
    ignore_changes = [source_details, ]
  }
  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    display_name = "${var.prefix}-nic"
    subnet_id    = oci_core_subnet.oci-subnet.id
  }
  shape_config {
    memory_in_gbs = var.oci_instance_memgb
    ocpus         = var.oci_instance_ocpus
  }
  source_details {
    source_id   = data.oci_core_image.oci-image.id
    source_type = "image"
    # source_id   = var.preserve_boot_volume == false ? data.oci_core_image.oci-image.id : base64decode(oci_vault_secret.boot_volume.secret_content.0.content)
    # source_type = var.preserve_boot_volume == true ? (startswith(base64decode(oci_vault_secret.boot_volume.secret_content.0.content), "ocid1.bootvolume") ? "bootVolume" : "image") : "image"
    kms_key_id = oci_kms_key.oci-kms-disk-key.id
    # Applicable when source_type=image
    boot_volume_size_in_gbs = var.oci_instance_diskgb
  }
  metadata = {
    ssh_authorized_keys = var.ssh_key
    user_data = base64encode(templatefile(
      "user_data.tpl",
      {
        oci_region        = local.oci_region
        tenancy_ocid      = var.tenancy_ocid
        web_port          = var.web_port
        project_directory = var.project_directory
        project_url       = var.project_url
        oci_kms_endpoint  = oci_kms_vault.oci-kms-vault.crypto_endpoint
        oci_kms_keyid     = oci_kms_key.oci-kms-storage-key.id
        # -------optional----------
        github_cipher        = oci_kms_encrypted_data.kms-ext-github-secret.ciphertext
        zerotier_ntwk_cipher = oci_kms_encrypted_data.kms-zerotier-ntwk-secret.ciphertext
        # -------end----------
      }
    ))
  }
  # depends_on = [oci_identity_policy.oci-id-instance-policy, oci_identity_policy.oci-id-bucket-policy, oci_identity_policy.oci-id-disk-policy]
}

# Testing outputs:

# output "boot_volume_source_type" {
#   value = var.preserve_boot_volume ? (startswith(oci_vault_secret.boot_volume.secret_value, "ocid1.bootvolume") ? "bootVolume" : "image") : "image"
# }    

# output "boot_volume_vault_test_result" {
#   value = (startswith(oci_vault_secret.boot_volume.secret_value, "ocid1.bootvolume") ? "bootVolume" : "image")
# }   

# output "preserve_test" {
#   value = (var.preserve_boot_volume == true)
# }
# output "preserve_value" {
#   value = var.preserve_boot_volume
# }