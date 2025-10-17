
locals {
  applist = [
    {
      hostname = "portainer_"
      service  = "https://${var.docker_portainer}:9443"
      origin_request = {
        origin_server_name = "*.thecraftkeeper.com"
      }
    },
    {
      hostname = "overseerr_"
      service  = "http://172.18.1.23:5055"
    },
    {
      hostname = "prowlarr_"
      service  = "http://172.18.1.22:9696"
    },
    {
      hostname = "radarr_"
      service  = "http://172.18.1.20:7878"
    },
    {
      hostname = "sonarr_"
      service  = "http://172.18.1.21:8989"
    },
    {
      hostname = "portal_"
      service  = "http://172.18.1.30:3000"
    }
    # {
    #   hostname           = "plex"
    #   service            = "https://192.168.86.4:32400"
    #   origin_server_name = "*.0dad5e2b20ec42af9db1ec6f3a1693dc.plex.direct"
    # }
  ]
  # Those are subdomains that don't share the subdomain suffix
  applist2 = [
    {
      hostname = "portal"
      service  = "http://172.18.1.30:3000"
    },
    {
      hostname = "plexrequests"
      service  = "http://172.18.1.23:5055"
    },
    {
      hostname = "code-server"
      service  = "http://172.18.1.10:8443"
    }
  ]
  catchall = [
    {
      service = "http_status:404"
    }
  ]
}
