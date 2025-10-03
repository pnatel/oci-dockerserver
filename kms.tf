resource "oci_kms_vault" "oci-kms-vault" {
  compartment_id = oci_identity_compartment.oci-compartment.id
  display_name   = "${var.prefix}-vault-${random_string.oci-random.result}"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "oci-kms-storage-key" {
  compartment_id      = oci_identity_compartment.oci-compartment.id
  display_name        = "${var.prefix}-storage-key-${random_string.oci-random.result}"
  management_endpoint = oci_kms_vault.oci-kms-vault.management_endpoint
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  protection_mode = "SOFTWARE"
}

/* resource "oci_kms_vault" "oci-kms-disk-vault" {
  compartment_id = oci_identity_compartment.oci-compartment.id
  display_name   = "${var.prefix}-disk-vault-${random_string.oci-random.result}"
  vault_type     = "DEFAULT"
} */

resource "oci_kms_key" "oci-kms-disk-key" {
  compartment_id      = oci_identity_compartment.oci-compartment.id
  display_name        = "${var.prefix}-disk-key-${random_string.oci-random.result}"
  management_endpoint = oci_kms_vault.oci-kms-vault.management_endpoint
  key_shape {
    algorithm = "AES"
    length    = 32
  }
  protection_mode = "SOFTWARE"
}

# # Passwords
# resource "random_password" "admin_password" {
#   length  = 32
#   special = false
# }

# resource "random_password" "db_password" {
#   length  = 32
#   special = false
# }

# resource "random_password" "oo_password" {
#   length  = 32
#   special = false
# }

# resource "random_password" "default_user_pwd" {
#   length  = 32
#   special = false
# }

# resource "random_password" "jwt_monitoring" {
#   length  = 32
#   special = false
# }

# # Pushing creds to OCI Vault
# resource "oci_vault_secret" "admin_password" {
#   compartment_id = oci_identity_compartment.oci-compartment.id
#   vault_id       = oci_kms_vault.oci-kms-vault.id
#   key_id         = oci_kms_key.oci-kms-storage-key.id
#   secret_name    = "admin_password"
#   description    = "Password for the Nextcloud Admin user. username: ${var.NC_ADMIN_USER}"
#   secret_content {
#     content_type = "BASE64"
#     content      = base64encode(random_password.admin_password.result)
#   }
# }

# resource "oci_vault_secret" "db_password" {
#   compartment_id = oci_identity_compartment.oci-compartment.id
#   vault_id       = oci_kms_vault.oci-kms-vault.id
#   key_id         = oci_kms_key.oci-kms-storage-key.id
#   secret_name    = "db_password"
#   description    = "Password for the Nextcloud MariaDB account. User: nextcloud"
#   secret_content {
#     content_type = "BASE64"
#     content      = base64encode(random_password.db_password.result)
#   }
# }

# resource "oci_vault_secret" "oo_password" {
#   compartment_id = oci_identity_compartment.oci-compartment.id
#   vault_id       = oci_kms_vault.oci-kms-vault.id
#   key_id         = oci_kms_key.oci-kms-storage-key.id
#   secret_name    = "oo_password"
#   description    = "JSON Web Token (JWT) for the OnlyOffice container."
#   secret_content {
#     content_type = "BASE64"
#     content      = base64encode(random_password.oo_password.result)
#   }
# }

# resource "oci_vault_secret" "default_user_pwd" {
#   compartment_id = oci_identity_compartment.oci-compartment.id
#   vault_id       = oci_kms_vault.oci-kms-vault.id
#   key_id         = oci_kms_key.oci-kms-storage-key.id
#   secret_name    = "default_user_pwd"
#   description    = "Pre-set password for any Nextcloud user created via CLI"
#   secret_content {
#     content_type = "BASE64"
#     content      = base64encode(random_password.default_user_pwd.result)
#   }
# }

# resource "oci_vault_secret" "oci-bucker-user-key-secret" {
#   compartment_id = oci_identity_compartment.oci-compartment.id
#   vault_id       = oci_kms_vault.oci-kms-vault.id
#   key_id         = oci_kms_key.oci-kms-storage-key.id
#   secret_name    = "oci-bucker-user-key-secret"
#   description    = "Secret used in the OCI buckets"
#   secret_content {
#     content_type = "BASE64"
#     content      = base64encode(oci_identity_customer_secret_key.oci-bucker-user-key.key)
#   }
# }

# resource "oci_vault_secret" "jwt_monitoring" {
#   compartment_id = oci_identity_compartment.oci-compartment.id
#   vault_id       = oci_kms_vault.oci-kms-vault.id
#   key_id         = oci_kms_key.oci-kms-storage-key.id
#   secret_name    = "jwt_monitoring"
#   description    = "Password for the Nextcloud MariaDB account. User: nextcloud"
#   secret_content {
#     content_type = "BASE64"
#     content      = base64encode(random_password.jwt_monitoring.result)
#   }
# }

# # Encrypting...
# resource "oci_kms_encrypted_data" "oci-kms-oci-user-secret" {
#   crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
#   key_id          = oci_kms_key.oci-kms-storage-key.id
#   # plaintext       = base64encode(random_password.default_user_pwd.result)
#   plaintext = oci_vault_secret.default_user_pwd.secret_content.0.content
# }

# resource "oci_kms_encrypted_data" "oci-kms-oci-admin-secret" {
#   crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
#   key_id          = oci_kms_key.oci-kms-storage-key.id
#   # plaintext       = base64encode(random_password.admin_password.result)
#   plaintext = oci_vault_secret.admin_password.secret_content.0.content
# }

# resource "oci_kms_encrypted_data" "oci-kms-oci-db-secret" {
#   crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
#   key_id          = oci_kms_key.oci-kms-storage-key.id
#   # plaintext       = base64encode(random_password.db_password.result)
#   plaintext = oci_vault_secret.db_password.secret_content.0.content
# }

# resource "oci_kms_encrypted_data" "oci-kms-oci-oo-secret" {
#   crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
#   key_id          = oci_kms_key.oci-kms-storage-key.id
#   # plaintext       = base64encode(random_password.oo_password.result)
#   plaintext = oci_vault_secret.oo_password.secret_content.0.content
# }

# resource "oci_kms_encrypted_data" "oci-kms-bucket-user-key-secret" {
#   crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
#   key_id          = oci_kms_key.oci-kms-storage-key.id
#   # plaintext       = base64encode(oci_identity_customer_secret_key.oci-bucker-user-key.key)
#   plaintext = oci_vault_secret.oci-bucker-user-key-secret.secret_content.0.content
# }

# resource "oci_kms_encrypted_data" "oci-kms-jwt-monitoring-secret" {
#   crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
#   key_id          = oci_kms_key.oci-kms-storage-key.id
#   plaintext       = oci_vault_secret.jwt_monitoring.secret_content.0.content
# }

# # ------Encrypting creds from Terraform Variables-----------
# resource "oci_kms_encrypted_data" "oci-kms-smtp-app-secret" {
#   crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
#   key_id          = oci_kms_key.oci-kms-storage-key.id
#   plaintext       = base64encode(var.SMTP_PASSWORD)
# }

# resource "oci_kms_encrypted_data" "oci-kms-ext-s3-key-secret" {
#   crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
#   key_id          = oci_kms_key.oci-kms-storage-key.id
#   plaintext       = base64encode(var.OBJECTSTORE_S3_KEY)
# }

# resource "oci_kms_encrypted_data" "oci-kms-ext-s3-secret-secret" {
#   crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
#   key_id          = oci_kms_key.oci-kms-storage-key.id
#   plaintext       = base64encode(var.OBJECTSTORE_S3_SECRET)
# }

resource "oci_kms_encrypted_data" "kms-zerotier-ntwk-secret" {
  crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
  key_id          = oci_kms_key.oci-kms-storage-key.id
  plaintext       = base64encode(var.zerotier_ntwk)
}

resource "oci_kms_encrypted_data" "kms-zerotier-token-secret" {
  crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
  key_id          = oci_kms_key.oci-kms-storage-key.id
  plaintext       = base64encode(var.zerotier_token)
}

resource "oci_kms_encrypted_data" "kms-ext-github-secret" {
  crypto_endpoint = oci_kms_vault.oci-kms-vault.crypto_endpoint
  key_id          = oci_kms_key.oci-kms-storage-key.id
  plaintext       = base64encode(var.github)
}

# # Boot volume in OCI Vault
# data "oci_core_boot_volumes" "boot_volumes" {
#   availability_domain = data.oci_identity_availability_domain.oci-availability-domain.name
#   compartment_id      = oci_identity_compartment.oci-compartment.id
# }

# resource "hcp_vault_secrets_app" "dockerhost-oci" {
#   app_name    = "${var.prefix}-dockerhost-oci"
#   description = "Store App variables accross deployments/upgrades"
# }

# resource "hcp_vault_secrets_secret" "boot_volume" {
#   app_name     = hcp_vault_secrets_app.dockerhost-oci.app_name
#   secret_name  = "boot_volume"
#   secret_value = length(data.oci_core_boot_volumes.boot_volumes.boot_volumes) > 0 ? (element(data.oci_core_boot_volumes.boot_volumes.boot_volumes, length(data.oci_core_boot_volumes.boot_volumes.boot_volumes) - 1).state == "AVAILABLE" ? element(data.oci_core_boot_volumes.boot_volumes.boot_volumes, length(data.oci_core_boot_volumes.boot_volumes.boot_volumes) - 1).id : data.oci_core_image.oci-image.id) : data.oci_core_image.oci-image.id
# }

# resource "oci_vault_secret" "boot_volume" {
#   compartment_id = oci_identity_compartment.oci-compartment.id
#   vault_id       = oci_kms_vault.oci-kms-vault.id
#   key_id         = oci_kms_key.oci-kms-storage-key.id
#   secret_name    = "boot_volume"
#   description    = "Boot volume ID to keep the volume across deployments"
#   secret_content {
#     content_type = "BASE64"
#     content      = base64encode(length(data.oci_core_boot_volumes.boot_volumes.boot_volumes) > 0 ? (element(data.oci_core_boot_volumes.boot_volumes.boot_volumes, length(data.oci_core_boot_volumes.boot_volumes.boot_volumes) - 1).state == "AVAILABLE" ? element(data.oci_core_boot_volumes.boot_volumes.boot_volumes, length(data.oci_core_boot_volumes.boot_volumes.boot_volumes) - 1).id : data.oci_core_image.oci-image.id) : data.oci_core_image.oci-image.id)
#   }
# }