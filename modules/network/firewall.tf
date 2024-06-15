resource "google_compute_firewall" "ssh" {
  name    = "${var.vpc_network_name}-firewall-ssh"
  network = var.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags   = ["${var.vpc_network_name}-firewall-ssh"]
  source_ranges = ["0.0.0.0/0"]
}



resource "google_compute_firewall" "http" {
  name    = "${var.vpc_network_name}-firewall-http"
  network = var.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags   = ["${var.vpc_network_name}-firewall-http"]
  source_ranges = ["0.0.0.0/0"]
}



resource "google_compute_firewall" "https" {
  name    = "${var.vpc_network_name}-firewall-https"
  network = var.vpc_network_name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  target_tags   = ["${var.vpc_network_name}-firewall-https"]
  source_ranges = ["0.0.0.0/0"]
}



resource "google_compute_firewall" "icmp" {
  name    = "${var.vpc_network_name}-firewall-icmp"
  network = var.vpc_network_name

  allow {
    protocol = "icmp"
  }

  target_tags   = ["${var.vpc_network_name}-firewall-icmp"]
  source_ranges = ["0.0.0.0/0"]
}
