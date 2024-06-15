terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0.0"
    }
  }
}

# GCP provider
provider "google" {
  # credentials = file(var.gcp_svc_key)
  project     = var.project_id
  region      = var.region1 #default region
}

# GCP beta provider
provider "google-beta" {
  # credentials = file(var.gcp_svc_key)
  project     = var.project_id
  region      = var.region1 #default region
}
