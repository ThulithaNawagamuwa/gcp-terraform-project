output "web_subnet1_self_link" {
  value = google_compute_subnetwork.vpc_web_subnet1.self_link
}

output "web_subnet2_self_link" {
  value = google_compute_subnetwork.vpc_web_subnet2.self_link
}
