variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "web_subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "web_subnet_ip" {
  description = "The IP range of the subnet"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}
