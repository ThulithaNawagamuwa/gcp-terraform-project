
resource "google_compute_instance_template" "appserver" {
  name_prefix = "appserver-template"
  description = "This template is used to create app server instances."

  tags = ["appserver-instance-template"]

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to instances"
  machine_type         = "e2-medium"
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image      = "debian-cloud/debian-11"
    auto_delete       = true
    boot              = true
  }

  network_interface {
    network = "web-app-vpc"
    subnetwork = "web-subnet"
  }

  metadata = {
    foo = "bar"
  }

  lifecycle {
    create_before_destroy = true
  }

}



# resource "google_compute_health_check" "autohealing" {
#   name                = "autohealing-health-check"
#   check_interval_sec  = 5
#   timeout_sec         = 5
#   healthy_threshold   = 2
#   unhealthy_threshold = 10 # 50 seconds

#   http_health_check {
#     request_path = "/healthz"
#     port         = "8080"
#   }
# }


resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  base_instance_name = "app"
  region             = "us-central1"
  target_size        = 2
  distribution_policy_zones  = ["us-central1-a", "us-central1-f"]

  version {
    instance_template = google_compute_instance_template.appserver.self_link_unique
  }

  named_port {
    name = "http"
    port = 80
  }

#   auto_healing_policies {
#     health_check      = google_compute_health_check.autohealing.id
#     initial_delay_sec = 300
#   }
}



output "target_tags" {
  value = ["appserver-mig"]  
}

output "instance_group" {
  value = google_compute_region_instance_group_manager.instance_group_manager.self_link
}