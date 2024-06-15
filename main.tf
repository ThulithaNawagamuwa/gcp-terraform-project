
module "network" {
  source           = "./modules/network"
  vpc_network_name = var.vpc_network_name
  web_subnet1_name = var.web_subnet1_name
  web_subnet1_ip   = var.web_subnet1_ip
  web_subnet2_name = var.web_subnet2_name
  web_subnet2_ip   = var.web_subnet2_ip
  region1          = var.region1
  region2          = var.region2
}


module "managed_instance_group_region1" {
  source               = "./modules/managed-instance-group"
  region               = var.region1
  vpc_network_name     = var.vpc_network_name
  web_subnet_self_link = module.network.web_subnet1_self_link # helps to create subnet before the instance group
  machine_type         = "e2-medium"
  source_image         = "debian-cloud/debian-11"
  environment          = "dev"
  zones                = ["us-central1-a", "us-central1-b"]
  target_size          = 2
  min_replicas         = 2
  max_replicas         = 4
}

module "managed_instance_group_region2" {
  source               = "./modules/managed-instance-group"
  region               = var.region2
  vpc_network_name     = var.vpc_network_name
  web_subnet_self_link = module.network.web_subnet2_self_link # helps to create subnet before the instance group
  machine_type         = "e2-medium"
  source_image         = "debian-cloud/debian-11"
  environment          = "dev"
  zones                = ["europe-north1-a", "europe-north1-b"]
  target_size          = 2
  min_replicas         = 2
  max_replicas         = 4
}

module "static_page" {
  source = "./modules/static-page"
}

module "load_balancer" {
  source                         = "./modules/load-balancer"
  project_id                     = var.project_id
  managed_instance_group_region1 = module.managed_instance_group_region1.app_instance_group
  managed_instance_group_region2 = module.managed_instance_group_region2.app_instance_group
  backend_bucket_id              = module.static_page.backend_bucket_id
}


module "database" {
  source             = "./modules/database"
  region1            = var.region1
  region2            = var.region2
  vpc_network_name   = var.vpc_network_name
  project_id         = var.project_id
  database_version   = "POSTGRES_15"
  database_disk_size = "10"
}





