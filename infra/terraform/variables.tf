######  Variables for Flask Application Deployment (passed from CI/CD)
variable "helm_chart_name" {
  description = "The name of the Helm chart for the Flask application."
  type        = string
}

variable "helm_chart_version" {
  description = "The version of the Helm chart for the Flask application."
  type        = string
}

variable "helm_chart_repo" {
  description = "The base OCI repository URL for the Helm chart (e.g., oci://ghcr.io)."
  type        = string
}

variable "docker_image_repo" {
  description = "The base Docker image repository (e.g., ghcr.io)."
  type        = string
}

variable "github_repo_owner" { # <-- Reverted to original name
  description = "The owner of the GitHub repository (e.g., your GitHub username or organization name)."
  type        = string
}

variable "docker_image_tag" { # <-- Reverted to original name
  description = "The version/tag of the Docker image from CI/CD."
  type        = string
}

# Unified Namespace for Flask App deployments
variable "flask_app_namespace" {
  description = "The Kubernetes namespace for the Flask application deployment."
  type        = string
  default     = "flask-app-ns"
}

variable "flask_app_service_name" {
  description = "The OpenTelemetry service name for the Flask application."
  type        = string
  default     = "flask-app-srv"
}

variable "git_repo_name" {
  description = "The name of the Git repository containing the Helm chart."
  type        = string
  default     = "terraform-flask-otel-repo" # Provide a sensible default
}
#############################################################################################################

### K3D -specific
variable "k3d_cluster_name" {
  description = "Name of the k3d cluster"
  type        = string
  default     = "tf-cluster"
}

variable "k3d_context_name" {
  description = "Name of the k3d context"
  type        = string
  default     = "k3d-tf-cluster"
}

variable "k3d_app_port" {
  description = "The host port to map the app to."
  type        = number
  default     = 8080
}

variable "k3d_app_container_port" {
  description = "The container port the app exposes."
  type        = number
  default     = 80
}

variable "enable_namespace_creation" {
  description = "Whether to create the app namespace (disable if it already exists)"
  type        = bool
  default     = true
}

variable "use_local_chart" {
  description = "If true, use a local Helm chart instead of an OCI registry chart"
  type        = bool
  default     = false
}

### Argo CD - specific
variable "argocd_host_port" {
  type    = string
  default = "30080"
}

variable "argocd_container_port" {
  type    = string
  default = "30080"
}

variable "enable_argocd_application" {
  description = "A flag to enable or disable the creation of the Argo CD application resource."
  type        = bool
  default     = true
}

variable "argocd_auth_token" {
  description = "The authentication token for the Argo CD API."
  type        = string
  sensitive   = true # Marks the value as sensitive in logs
}