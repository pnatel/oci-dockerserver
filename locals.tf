
locals {
  applist = [
    {
      hostname = "portainer_${var.dns_domain}"
      service  = "https://${var.docker_portainer}:9443"
      origin_request = {
        origin_server_name = "*.thecraftkeeper.com"
      }
    },
    {
      hostname = "overseerr_${var.dns_domain}"
      service  = "http://172.18.1.23:5055"
    },
    {
      hostname = "prowlarr_${var.dns_domain}"
      service  = "http://172.18.1.22:9696"
    },
    {
      hostname = "radarr_${var.dns_domain}"
      service  = "http://172.18.1.20:7878"
    },
    {
      hostname = "sonarr_${var.dns_domain}"
      service  = "http://172.18.1.21:8989"
    },
    {
      hostname = "portal_${var.dns_domain}"
      service  = "http://172.18.1.30:3000"
    },
    {
      hostname = "portal.${join(".", slice(split(".", var.dns_domain), 1, 3))}"
      service  = "http://172.18.1.30:3000"
    },
    {
      hostname = "plexrequests.${join(".", slice(split(".", var.dns_domain), 1, 3))}"
      service  = "http://172.18.1.23:5055"
    },
    {
      hostname = "code-server.${join(".", slice(split(".", var.dns_domain), 1, 3))}"
      service  = "http://172.18.1.10:8443"
    },
    {
      hostname = "librephotos_${var.dns_domain}"
      service  = "http://172.18.1.40"
    },
    {
      hostname = "ebooks-${var.dns_domain}"
      service  = "http://172.18.1.33:8083"
    },
    {
      hostname = "ebooks-requests-${var.dns_domain}"
      service  = "http://172.18.1.34:8084"
      # },
      # # ---------public facing apps----------
      # # immich
      # {
      #   hostname = "photos.${join(".", slice(split(".", var.dns_domain), 1, 3))}"
      #   service  = "http://172.18.1.51:2283"
    }
  ]
  catchall = [
    {
      service = "http_status:404"
    }
  ]
}
