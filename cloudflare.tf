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

resource "cloudflare_dns_record" "portainer" {
  zone_id = var.cloudflare_zone_id
  name    = "portainer-${split(".", var.dns_domain)[0]}"
  ttl     = 1
  type    = "CNAME"
  comment = "CNAME record that routes portainer-${var.dns_domain} to the tunnel"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.auto_tunnel.id}.cfargotunnel.com"
  proxied = true
}

# Creates the configuration for the tunnel.
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "auto_tunnel" {
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.auto_tunnel.id
  account_id = var.cloudflare_account_id
  config = {
    ingress = [{
      hostname = "portainer-${var.dns_domain}"
      service  = "https://${var.docker_portainer}:9443"
      origin_request = {
        no_tls_verify = true
      }
      },
      {
        service = "http_status:404"
    }]
  }
}


# Creates an Access application to control who can connect to Nextcloud.
resource "cloudflare_zero_trust_access_application" "portainer_app" {
  zone_id          = var.cloudflare_zone_id
  name             = "Access application for portainer-${var.dns_domain}"
  domain           = var.dns_domain
  session_duration = "24h"
}

# Creates an Access policy for the application.
resource "cloudflare_zero_trust_access_policy" "portainer_policy" {
  account_id = var.cloudflare_account_id

  # application_id = cloudflare_zero_trust_access_application.portainer_app.id
  # zone_id        = var.cloudflare_zone_id
  name           = "Policy for ${var.dns_domain}"
  # precedence     = "1"
  decision       = "allow"
  include = [{
    # email = [var.cloudflare_email]
    email_domain = [split("@", var.cloudflare_email)[1]]
  }]
}

# # Creates a bypass rule to allow access to local applications to the Nextcloud app without authentication.

# resource "cloudflare_zero_trust_access_policy" "nextcloud_bypass" {
#   zone_id        = var.cloudflare_zone_id
#   application_id = cloudflare_zero_trust_access_application.nextcloud_app.id
#   name           = "Bypass rule for ${var.dns_domain}"
#   precedence     = "2"
#   decision       = "bypass"
#   include {
#     ip_list = [ var.docker_network ]
#   }
# }


# --------- END BUG -----------

# Creates an Access application to control who can connect to OnlyOffice.
/* resource "cloudflare_access_application" "onlyoffice_app" {
  count            = var.enable_dns == 2 ? 1 : 0
  zone_id          = var.cloudflare_zone_id
  name             = "Access application for ${var.dns_domain}-onlyoffice"
  domain           = "oo.${var.dns_domain}"
  session_duration = "1h"
} */

# Creates an Access policy for the application.
/* resource "cloudflare_access_policy" "onlyoffice_policy" {
  count          = var.enable_dns == 2 ? 1 : 0
  application_id = cloudflare_access_application.onlyoffice_app[count.index].id
  zone_id        = var.cloudflare_zone_id
  name           = "Policy for ${var.dns_domain}-onlyoffice"
  precedence     = "1"
  decision       = "allow"
  include {
    email = [var.cloudflare_email]
  }
} */

# # Onlyoffice welcome redirection
# resource "cloudflare_page_rule" "OO-redirect-to-main-site" {
#   count    = var.enable_dns == 2 ? 1 : 0
#   priority = 1
#   status   = "active"
#   target   = "https://oo-${var.dns_domain}/welcome/"
#   zone_id  = var.cloudflare_zone_id
#   actions {
#     forwarding_url {
#       status_code = 301
#       url         = "https://${var.dns_domain}/"
#     }
#   }
# }

# ------------START---------------
# Creates a Cloudflare ruleset to rewrite URLs for Nextcloud.
# THE BELOW AFFECTS THE DOMAIN AS A WHOLE AND IS NOT REUSABLE
# only enable it if you don't have any other conflicting resources in the same domain
# resource "cloudflare_ruleset" "transform_url_rewrite" {
#   count       = var.enable_dns == 2 ? 1 : 0
#   zone_id     = var.cloudflare_zone_id
#   name        = "Transform Rule for Nextcloud DAV"
#   description = "DAV rule for Nextcloud"
#   kind        = "zone"
#   phase       = "http_request_transform"

#   rules {
#     action = "rewrite"
#     action_parameters {
#       uri {
#         path {
#           value = "/remote.php/dav"
#         }
#       }
#     }
#     expression = "(http.request.uri eq \"/.well-known/carddav\") or (http.request.uri eq \"/.well-known/caldav\")"
#     #"(http.host eq \"example.com\" and http.request.uri.path eq \"/old-folder\")"
#     description = "DAV Rewrite URL Rule"
#     enabled     = true
#   }
#   rules {
#     action = "rewrite"
#     action_parameters {
#       uri {
#         path {
#           value = "/nextcloud/index.php/.well-known/"
#         }
#       }
#     }
#     expression = "(http.request.uri eq \"/.well-known\") or (http.request.uri eq \"/.well-known/\")"
#     #"(http.host eq \"example.com\" and http.request.uri.path eq \"/old-folder\")"
#     description = "/.well-known Rewrite URL Rule"
#     enabled     = true
#   }
# }


# resource "cloudflare_ruleset" "country_block" {
#   count   = var.enable_dns == 2 ? 1 : 0
#   zone_id = var.cloudflare_zone_id
#   name    = "Traffic only from AU BR AR and US"
#   kind    = "zone"
#   phase   = "http_request_firewall_custom"

#   rules {
#     action     = "block"
#     expression = "(not ip.geoip.country in {\"AU\" \"BR\" \"AR\" \"US\"})"
#     enabled    = true
#   }
# }

# # Creates the CNAME record that routes var.NEXTCLOUD_TRUSTED_DOMAINS[x] to cloudflare_record.nextcloud_app.name
# MISSING THE TUNNEL CONFIGURATION
# resource "cloudflare_record" "nextcloud_trusted_domains" {
#   count   = var.enable_dns == 2 && length(split(" ", var.NEXTCLOUD_TRUSTED_DOMAINS)) > 0 ? length(split(" ", var.NEXTCLOUD_TRUSTED_DOMAINS)) : 0
#   zone_id = var.cloudflare_zone_id
#   name    = split(" ", var.NEXTCLOUD_TRUSTED_DOMAINS)[count.index]
#   content = cloudflare_record.nextcloud_app[0].content
#   type    = "CNAME"
#   proxied = true
# }

# ------------END---------------


