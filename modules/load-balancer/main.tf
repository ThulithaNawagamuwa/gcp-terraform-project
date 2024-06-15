# Reserve an external IP
resource "google_compute_global_address" "website" {
  provider = google
  name     = "website-lb-ip"
}

# Get the managed DNS zone
data "google_dns_managed_zone" "custom_dns_zone" {
  provider = google
  name     = "gcp-terraform-dns-zone"
}

# Add the IP to the DNS
resource "google_dns_record_set" "website" {
  provider     = google
  name         = "www.${data.google_dns_managed_zone.custom_dns_zone.dns_name}" # The fully qualified domain name (FQDN) for the DNS record.
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.custom_dns_zone.name
  rrdatas      = [google_compute_global_address.website.address] # Adding external IP address to the DNS record
}

resource "google_compute_health_check" "default" {
  name               = "tcp-proxy-health-check"
  timeout_sec        = 5
  check_interval_sec = 5
  healthy_threshold  = 4
  unhealthy_threshold = 5

  tcp_health_check {
    port = "80"
  }

  log_config {
    enable = true
  }
}

# backend service with custom request and response headers
resource "google_compute_backend_service" "default" {
  name                = "mig-backend-service"
  project             = var.project_id
  protocol            = "HTTP"
  session_affinity    = "NONE"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec         = 10
  enable_cdn          = true   # Enable CDN
  health_checks       = [google_compute_health_check.default.id]
  backend {
    group           = var.managed_instance_group_region1
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
    max_utilization = 0.8
  }
  backend {
    group           = var.managed_instance_group_region2
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
    max_utilization = 0.8
  }

  depends_on = [
    google_compute_health_check.default
  ]
}

# # Create HTTPS certificate
# resource "google_compute_managed_ssl_certificate" "website" {
#   provider = google-beta
#   name     = "website-cert"
#   managed {
#     domains = [google_dns_record_set.website.name]
#   }
# }


resource "google_compute_url_map" "website" {
  name            = "website-url-map"
  default_service = google_compute_backend_service.default.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.id

    path_rule {
      paths = ["/static", "/static/*"]
      service = var.backend_bucket_id
    }

    path_rule {
      paths = ["/home", "/home/*"]
      service = google_compute_backend_service.default.id
    }

    path_rule {
      paths = ["/home_page"]
      service = google_compute_backend_service.default.id
    }

    
  }
  
}


### GCP target HTTPS proxy ###

# resource "google_compute_target_https_proxy" "website" {
#   provider         = google
#   name             = "website-target-proxy"
#   url_map          = google_compute_url_map.website.self_link
#   ssl_certificates = [google_compute_managed_ssl_certificate.website.self_link]
# }


# GCP target HTTP proxy
resource "google_compute_target_http_proxy" "website" {
  name    = "website-target-proxy"
  url_map = google_compute_url_map.website.self_link
  depends_on = [
    google_compute_url_map.website
  ]
}

# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  provider              = google
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website.address
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.website.self_link
  depends_on = [
    google_compute_target_http_proxy.website
  ]
}
