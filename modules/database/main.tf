# Create a private IP range for the VPC
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc_network_name
}

# Establish a private connection to Google services
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.vpc_network_name
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}


# Primary Cloud SQL instance configuration
resource "google_sql_database_instance" "master" {
  name             = "app-db-master"
  region           = var.region1
  database_version = var.database_version
  depends_on =    [google_service_networking_connection.private_vpc_connection]
  deletion_protection = false

  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = var.database_disk_size
    backup_configuration {
      enabled = true
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project_id}/global/networks/${var.vpc_network_name}"
    }
  }
}



# Read replica Cloud SQL instance configuration
resource "google_sql_database_instance" "read_replica" {
  name                 = "app-db-read-replica"
  master_instance_name = "${google_sql_database_instance.master.name}"
  region               = var.region2
  database_version     = var.database_version
  deletion_protection = false
  replica_configuration {
    failover_target = false
  }
  depends_on =    [google_service_networking_connection.private_vpc_connection]
  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = var.database_disk_size
    backup_configuration {
      enabled = false
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project_id}/global/networks/${var.vpc_network_name}"
    }
  }
}


# Retrieve the secret from Google Secret Manager
data "google_secret_manager_secret_version" "db_root_password" {
  secret  = "db-root-password"
  version = "latest"
}


# Configure a root user for the primary Cloud SQL instance
resource "google_sql_user" "root" {
  name     = "root"
  instance = google_sql_database_instance.master.name
  password = data.google_secret_manager_secret_version.db_root_password.secret_data
}

# Create an example database in the primary Cloud SQL instanc
resource "google_sql_database" "example_db" {
  name     = "exampledb"
  instance = google_sql_database_instance.master.name
}

