variable "k3d_cluster_name" {
  description = "Name of the k3d cluster"
  type        = string
  default     = "tf-k3d-cluster"
}

variable "chart_name" {
  type = string
}

variable "chart_version" {
  type = string
}

variable "chart_repo" {
  type = string
}

variable "image_repository" {
  type = string
}

variable "image_tag" {
  type = string
}
