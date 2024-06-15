terraform {
  backend "gcs" {
    bucket = "terraform-state-bucket-gcp"
    prefix = "terraform/state"
  }
}

