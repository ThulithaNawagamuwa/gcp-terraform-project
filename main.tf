resource "google_storage_bucket" "my-bucket" {
  name          = "gh-action-demo-001"
  location      = "US"
  project       = "gcp-terraform-project-424308"
  force_destroy = true

  public_access_prevention = "enforced"
}

module "network" {
  source      = "./modules/network"
  vpc_name    = var.vpc_name
  web_subnet_name = var.web_subnet_name
  web_subnet_ip = var.web_subnet_ip
  region      = var.region
}

module "managed_instance_group" {
  source = "./modules/mig"
}

module "http-loadbalancer" {
  source = "./modules/loadbalancer"
}