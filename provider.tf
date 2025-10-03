terraform {
  # ------remove the following block if not using the TF Cloud--------
  # The configuration for the `remote` backend.
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "pnatel"
    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "oci-dockerserver"
      # use with "terraform workspace" command to set the woekspace 
      # prefix = "dockerhost-oci-"
    }
  }
  # -------end-------
  required_providers {
    oci = {
      source = "oracle/oci"
    }
    # cloudflare = {
    #   source  = "cloudflare/cloudflare"
    #   version = "4.45.0"
    # }
    random = {
      source = "hashicorp/random"
    }
    # hcp = {
    #   source = "hashicorp/hcp"
    # }
  }
  required_version = ">= 1.10.0"
}

# Providers
provider "oci" {
  # requires an API key in the user profile
  # follow https://database-heartbeat.com/2021/10/05/auth-cli/
  # Authentication Method #1: User Principals
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key
  region       = var.region
  # use with "oci session authenticate"
  # auth                = "SecurityToken"
  # config_file_profile = var.config_file_profile
}
provider "cloudflare" {
  api_token = var.cloudflare_token
}
provider "random" {
}

# provider "hcp" {
#   # Configuration options
#   client_id     = var.HCP_CLIENT_ID
#   client_secret = var.HCP_CLIENT_SECRET
# }
