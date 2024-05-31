variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "gcp-terraform-project-424308"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "web-app-vpc"
}

variable "web_subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "web-subnet"
}

variable "web_subnet_ip" {
  description = "The IP range of the subnet"
  type        = string
  default     = "10.0.0.0/16"
}

