variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region1" {
  description = "The default GCP region"
  type        = string
}

variable "region2" {
  description = "The 2nd GCP region"
  type        = string
}

variable "vpc_network_name" {
  description = "The name of the VPC"
  type        = string
}

variable "web_subnet1_name" {
  description = "The name of the web subnet 1"
  type        = string
}

variable "web_subnet1_ip" {
  description = "The IP range of the web subnet 1"
  type        = string
}

variable "web_subnet2_name" {
  description = "The name of the web subnet 2"
  type        = string
}

variable "web_subnet2_ip" {
  description = "The IP range of the web subnet 2"
  type        = string
}


