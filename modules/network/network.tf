resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_web_subnet" {
  name          = var.web_subnet_name
  ip_cidr_range = var.web_subnet_ip
  region        = var.region
  network       = google_compute_network.vpc_network.name
}
