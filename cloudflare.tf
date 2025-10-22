data "cloudflare_zero_trust_tunnel_cloudflared_token" "tunnel_cloudflared_token" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.auto_tunnel.id
}

# Generates a 35-character secret for the tunnel.
resource "random_id" "tunnel_secret" {
  byte_length = 35
}

# Creates a new locally-managed tunnel for the VM.
resource "cloudflare_zero_trust_tunnel_cloudflared" "auto_tunnel" {
  account_id    = var.cloudflare_account_id
  name          = "${var.prefix}-oci-tunnel-${random_string.oci-random.result}"
  config_src    = "cloudflare"
  tunnel_secret = random_id.tunnel_secret.b64_std
}

# resource "cloudflare_zero_trust_tunnel_warp_connector" "tunnel_warp_connector" {
#   account_id    = var.cloudflare_account_id
#   name          = "${var.prefix}-warp-tunnel-${random_string.oci-random.result}"
#   tunnel_secret = random_id.tunnel_secret.b64_std

# }

resource "cloudflare_dns_record" "tunnel_dns_record" {
  count   = length(local.applist)
  zone_id = var.cloudflare_zone_id
  name    = split(".", local.applist[count.index].hostname)[0]
  ttl     = 1
  type    = "CNAME"
  comment = "CNAME record that routes ${local.applist[count.index].hostname} to the tunnel"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.auto_tunnel.id}.cfargotunnel.com"
  proxied = true
}

# Creates an Access application to control who can connect to Nextcloud.
resource "cloudflare_zero_trust_access_application" "access_app" {
  count                       = length(local.applist)
  zone_id                     = var.cloudflare_zone_id
  allow_authenticate_via_warp = true
  name                        = "Access application for ${split(".", local.applist[count.index].hostname)[0]}"
  domain                      = local.applist[count.index].hostname
  type                        = "self_hosted"
  session_duration            = "24h"
  policies = [{
    id         = cloudflare_zero_trust_access_policy.site_policy.id
    precedence = 1
  }]
}

# Creates the configuration for the tunnel.
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "auto_tunnel" {
  # count      = length(local.applist)
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.auto_tunnel.id
  account_id = var.cloudflare_account_id
  config = {
    ingress = concat(local.applist, local.catchall)
    # READ ONLY LINKED WITH ERROR ON DEPLOYMENT
    # warp_routing = {
    #   enabled = true
    # }
  }
}


# Creates an Access policy for the application.
resource "cloudflare_zero_trust_access_policy" "site_policy" {
  account_id = var.cloudflare_account_id
  name       = "Policy for ${var.dns_domain} sites"
  decision   = "allow"
  include = [{
    email_domain = {
      domain = split("@", var.cloudflare_email)[1]
    }
  }]
}


