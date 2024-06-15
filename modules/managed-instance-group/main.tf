
resource "google_compute_instance_template" "appserver" {
  name_prefix   = "appserver-template-${var.region}-"
  description   = "This template is used to create app server instances in ${var.region}."

  tags = [
    "appserver-instance-template",
    "${var.vpc_network_name}-firewall-ssh",
    "${var.vpc_network_name}-firewall-http",
    "${var.vpc_network_name}-firewall-https",
    "${var.vpc_network_name}-firewall-icmp"
  ]

  labels = {
    environment = var.environment
  }

  instance_description = "description assigned to instances"
  machine_type         = var.machine_type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  // Create a new boot disk from an image
  disk {
    source_image = var.source_image
    auto_delete       = true
    boot              = true
  }

  network_interface {
    network = var.vpc_network_name
    subnetwork = var.web_subnet_self_link
    # access_config {}                       # to assign an external ephemeral IP
  }

  metadata = {
    startup-script = file("${path.module}/startup-script.sh")
  }

  lifecycle {
    create_before_destroy = true
  }

}



resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check-${var.region}"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10   #50 seconds

  http_health_check {
    request_path = "/"
    port         = "80"
  }

  log_config {
    enable = true
  }
}


resource "google_compute_region_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager-${var.region}"
  base_instance_name = "app-${var.region}"
  region             = var.region
  target_size        = var.target_size
  distribution_policy_zones = var.zones

  version {
    instance_template = google_compute_instance_template.appserver.self_link_unique
  }

  named_port {
    name = "http"
    port = 80
  }

  update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_surge_fixed       = var.max_surge
    max_unavailable_fixed = var.max_unavailable
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 100    # Set this based on the application's startup time
  }
}


resource "google_compute_region_autoscaler" "appserver_autoscaler" {
  name   = "appserver-autoscaler-${var.region}"
  region = var.region

  target = google_compute_region_instance_group_manager.instance_group_manager.id

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}


