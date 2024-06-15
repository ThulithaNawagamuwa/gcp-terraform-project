variable "region" {
  description = "Region for the instance group"
  type        = string
}

variable "vpc_network_name" {
  description = "VPC network name"
  type        = string
}

variable "web_subnet_self_link" {
  description = "The self link of the subnet"
}

variable "environment" {
  description = "Environment label"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the instances"
  type        = string
}

variable "source_image" {
  description = "Source image for the instances"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "target_size" {
  description = "Target size for the instance group"
  type        = number
  default     = 2
}

variable "zones" {
  description = "Zones for the distribution policy"
  type        = list(string)
}

variable "max_surge" {
  description = "Maximum surge for the update policy"
  type        = number
  default     = 2
}

variable "max_unavailable" {
  description = "Maximum unavailable instances for the update policy"
  type        = number
  default     = 2
}

variable "min_replicas" {
  description = "Minimum number of replicas for autoscaling"
  type        = number
}

variable "max_replicas" {
  description = "Maximum number of replicas for autoscaling"
  type        = number
}

