resource "google_storage_bucket" "my-bucket" {
  name          = "gh-action-demo-001"
  location      = "US"
  project       = "gcp-terraform-project-424308"
  force_destroy = true

  public_access_prevention = "enforced"
}
