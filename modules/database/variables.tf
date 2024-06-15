variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region1" {
  description = "Region where the master db will be deployed"
  type = string
}

variable "region2" {
  description = "Region where the read replica db will be deployed"
  type = string
}

variable "vpc_network_name" {
  description = "The name of the VPC"
  type        = string
}

variable "database_version" {
  description = "Version of the DB"
  type        = string
}

variable "database_disk_size" {
  description = "Disk size of the DB"
  type        = string
}

# variable "db_subnet1_name" {
#   description = "The name of the db subnet 1"
#   type        = string
# }

# variable "db_subnet2_name" {
#   description = "The name of the db subnet 2"
#   type        = string
# }

