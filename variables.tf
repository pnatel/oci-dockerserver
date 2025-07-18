variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key" {}
locals {
  oci_region = lower(var.region)
}

/* variable "oci_config_profile" {
  type        = string
  description = "The oci configuration file, generated by 'oci setup config'"
} */

variable "tenancy_ocid" {
  # variable "oci_root_compartment" {
  type        = string
  description = "The tenancy OCID a.k.a. root compartment, see README for CLI command to retrieve it."
}

variable "region" {
  type        = string
  description = "Region to deploy services in."
}

# Get image info from https://docs.oracle.com/en-us/iaas/images/index.htm
# Alternatively:
# Run the following command to retrieve the latest Ubuntu 22.04 LTS image
#    OCI_TENANCY_OCID=$(oci iam compartment list --all --compartment-id-in-subtree true --access-level ACCESSIBLE --include-root --raw-output --query "data[?contains(\"id\",'tenancy')].id | [0]") && oci compute image list --compartment-id $OCI_TENANCY_OCID --all --lifecycle-state 'AVAILABLE' --operating-system "Canonical Ubuntu" --operating-system-version "24.04" --sort-by "TIMECREATED" | grep 'display-name\|ocid'
    # "display-name": "Canonical-Ubuntu-24.04-aarch64-2025.05.20-0",
    # "id": "ocid1.image.oc1.us-sanjose-1.aaaaaaaa43mwu75532lsj655xqgl4flkmlzbpin54ccoddrkpoyygzh4pvmq",
    # "display-name": "Canonical-Ubuntu-24.04-aarch64-2025.05.20-0",
    # "id": "ocid1.image.oc1.ap-sydney-1.aaaaaaaarcbc3y6yx6nmsu5rfipwz362oiex4xv2ullte7leheohvxam5kpa",
    # "display-name": "Canonical-Ubuntu-24.04-aarch64-2025.05.20-0",
    # "id": "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaawov7fxz5kmg3wzxmdc64cee7cdpgeo76yef3qdyttu4xnzbzhprq",
variable "oci_imageid" {
  type        = string
  description = "An OCID of an image, the playbook is compatible with Ubuntu 18.04+ minimal"
  default = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaawov7fxz5kmg3wzxmdc64cee7cdpgeo76yef3qdyttu4xnzbzhprq"
}

variable "oci_adnumber" {
  type        = number
  description = "The OCI Availability Domain, only certain AD numbers are free-tier, like Ashburn's 2"
  default     = 1
}

variable "oci_instance_shape" {
  type        = string
  description = "The size of the compute instance, only certain sizes are free-tier"
  # ARM 
  default = "VM.Standard.A1.Flex"
  # x86
  # default = "VM.Standard.E2.1.Micro"
}

variable "oci_instance_diskgb" {
  type        = string
  description = "Size of system boot disk, in gb"
  default     = 100
}

variable "oci_instance_memgb" {
  type        = string
  description = "Memory GB(s) for instance"
  default     = 24
}

variable "oci_instance_ocpus" {
  type        = string
  description = "Oracle CPUs for instance"
  default     = 4
}

variable "ssh_key" {
  type        = string
  description = "Public SSH key for SSH to compute instance, user is ubuntu"
}

variable "vcn_cidr" {
  type        = string
  description = "Subnet (in CIDR notation) for the OCI network, change if would overlap existing resources"
  default     = "10.10.12.0/24"
}

variable "mgmt_cidr" {
  type        = string
  description = "Subnet (in CIDR notation) granted access to Pihole WebUI and SSH running on the compute instance. Also granted DNS access if dns_novpn = 1"
}

variable "prefix" {
  type        = string
  description = "A friendly prefix (like 'pihole') affixed to many resources, like the bucket name."
  default = "dckrsvr"
}
/* 
variable "admin_password" {
  type        = string
  description = "Password for WebUI access"
}

variable "db_password" {
  type        = string
  description = "Nextcloud application db password"
}

variable "oo_password" {
  type        = string
  description = "Nextcloud application onlyoffice password"
} */

variable "project_url" {
  type        = string
  description = "URL of the git project"
  default = "https://github.com/pnatel/oci-dockerserver.git"
}

# # -------Gsilva custom bits----------
# variable "github" {
#   type        = string
#   description = "URL of the git scripts"
# }

# variable "zerotier_ntwk" {
#   type = string
# }

# -----end---------

# variable "docker_network" {
#   type        = string
#   description = "docker network ip"
#   default     = "172.18.1.0"
# }

# variable "docker_gw" {
#   type        = string
#   description = "docker network gateway ip"
#   default     = "172.18.1.1"
# }

# variable "docker_nextcloud" {
#   type        = string
#   description = "nextcloud app container ip"
#   default     = "172.18.1.2"
# }

# variable "docker_webproxy" {
#   type        = string
#   description = "https web proxy container ip"
#   default     = "172.18.1.3"
# }

# variable "docker_db" {
#   type        = string
#   description = "db container ip"
#   default     = "172.18.1.4"
# }

# variable "docker_redis" {
#   type        = string
#   description = "Redis container ip"
#   default     = "172.18.1.5"
# }

# variable "docker_onlyoffice" {
#   type        = string
#   description = "onlyoffice container"
#   default     = "172.18.1.6"
# }

# variable "docker_duckdnsupdater" {
#   type        = string
#   description = "duckdns dynamic dns update container ip"
#   default     = "172.18.1.10"
# }

# variable "docker_talk_hpb" {
#   type        = string
#   description = "Nextcloud Talk High Performance Backend container ip"
#   default     = "172.18.1.11"
# }

variable "project_directory" {
  type        = string
  description = "Location to install/run project"
  default     = "/docker"
}

variable "web_port" {
  type        = string
  description = "Port to run web proxy"
  default     = "443"
}

# variable "enable_dns" {
#   type        = number
#   description = "Use 0 for public IP, 1 for DuckDNS, and 2 for Cloudflare"
#   default     = 0
# }

# variable "dns_domain" {
#   type        = string
#   description = "FQDN"
#   default     = ""
# }

# variable "dns_token" {
#   type        = string
#   description = "DynDNS or Cloudflare token"
#   default     = ""
# }

# variable "letsencrypt_email" {
#   type    = string
#   default = "email@domain.tld"
# }

# #---
# variable "SMTP_NAME" {
#   type = string
# }

# variable "SMTP_PASSWORD" {
#   type = string
# }

# variable "MAIL_FROM_ADDRESS" {
#   type = string
# }

# variable "MAIL_DOMAIN" {
#   type = string
# }

# variable "NC_ADMIN_USER" {
#   type = string
# }

# variable "OBJECTSTORE_S3_KEY" {
#   type        = string
#   description = "S3 key to access the S3 account"
# }

# variable "OBJECTSTORE_S3_SECRET" {
#   type        = string
#   description = "S3 secret to access the S3 account"
# }

# variable "OBJECTSTORE_S3_REGION" {
#   type        = string
#   description = "S3 region to access the S3 account"
# }

# variable "OBJECTSTORE_S3_HOSTNAME" {
#   type        = string
#   description = "S3 hostname (endpoint URL) to access the S3 account"
# }
# variable "NEXTCLOUD_TRUSTED_DOMAINS" {
#   type        = string
#   description = "Extra domains eg: 'domain.com sub.domain.org' "
# }

# /* variable "disk_index" {
#   type        = string
#   description = "Provide the index for the boot volume in this deployment https://cloud.oracle.com/block-storage/boot-volumes"
#   default     = "0"
# } */

# # Cloudflare variables
# variable "cloudflare_zone_id" {
#   description = "Zone ID for your domain"
#   type        = string
#   default     = ""
# }

# variable "cloudflare_account_id" {
#   description = "Account ID for your Cloudflare account"
#   type        = string
#   sensitive   = true
#   default     = ""
# }

# variable "cloudflare_email" {
#   description = "Email address for your Cloudflare account"
#   type        = string
#   sensitive   = true
#   default     = ""
# }

# variable "cloudflare_token" {
#   description = "Cloudflare API token created at https://dash.cloudflare.com/profile/api-tokens"
#   type        = string
#   sensitive   = true
#   default     = "0123456789012345678901234567890123456789"
# }

# #-------Vault----------
# variable "HCP_CLIENT_ID" {
#   type = string
# }
# variable "HCP_CLIENT_SECRET" {
#   type = string
# }

variable "preserve_boot_volume" {
  type        = bool
  description = "Preserve boot volume between deployments. false(DEV)/true(PROD)"
  default     = false
}

# # backups: 5 are within the OCI always free tier:
# # 4 weekly and 1 manual backup (not part of this terraform code)
# variable "backup_retention" {
#   type        = number
#   description = "retention_seconds - How long, in seconds, to keep the volume backups created by this schedule."
#   default     = 2419200 # 4 weeks
# }