resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc_web_subnet1" {
  name          = var.web_subnet1_name
  ip_cidr_range = var.web_subnet1_ip
  region        = var.region1
  network       = google_compute_network.vpc_network.name

  depends_on = [
    google_compute_network.vpc_network
  ]
}

resource "google_compute_subnetwork" "vpc_web_subnet2" {
  name          = var.web_subnet2_name
  ip_cidr_range = var.web_subnet2_ip
  region        = var.region2
  network       = google_compute_network.vpc_network.name

  depends_on = [
    google_compute_network.vpc_network
  ]
}




