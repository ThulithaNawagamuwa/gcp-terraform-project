resource "google_compute_router" "nat-router-region1" {
  name    = "nat-router-${var.region1}"
  region  = "${var.region1}"
  network  = var.vpc_network_name
}

resource "google_compute_router_nat" "nat-config-region1" {
  name                               = "nat-config-${var.region1}"
  router                             = "${google_compute_router.nat-router-region1.name}"
  region                             = "${var.region1}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}



resource "google_compute_router" "nat-router-region2" {
  name    = "nat-router-${var.region2}"
  region  = "${var.region2}"
  network  = var.vpc_network_name
}

resource "google_compute_router_nat" "nat-config-region2" {
  name                               = "nat-config-${var.region2}"
  router                             = "${google_compute_router.nat-router-region2.name}"
  region                             = "${var.region2}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}