variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "managed_instance_group_region1" {
  description = "The self-link of the managed instance group in region 1"
  type        = string
}

variable "managed_instance_group_region2" {
  description = "The self-link of the managed instance group in region 2"
  type        = string
}

variable "backend_bucket_id" {
  description = "The ID of the backend bucket for serving static content"
  type        = string
}
