variable "k3d_cluster_name" {
  description = "Name of the k3d cluster"
  type        = string
  default     = "tf-cluster"
}

variable "helm_chart_name" {
  type = string
}

variable "helm_chart_version" {
  type = string
}

variable "helm_chart_repo" {
  description = "The base OCI repository URL for the Helm chart (e.g., oci://ghcr.io)."
  type        = string
  default     = "oci://ghcr.io" # Added default
}

variable "docker_image_repo" {
  description = "The base Docker image repository (e.g., ghcr.io)."
  type        = string
  default     = "ghcr.io" # Added default
}

variable "docker_image_tag" {
  type = string
}

variable "github_repo_owner" {
  description = "The owner of the GitHub repository (e.g., your GitHub username or organization name)."
  type        = string
}