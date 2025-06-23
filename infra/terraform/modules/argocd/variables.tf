variable "flask_app_name" {
  description = "The name of the Flask application used in Argo CD Application manifest"
  type        = string
  default     = "flask-app"
}

variable "repo_url" {
  description = "Git repository URL that contains the Helm chart"
  type        = string
  default     = "https://github.com/alkon/terraform-flask-otel-repo.git"
}

variable "repo_revision" {
  description = "Git revision (e.g., branch, tag, or commit SHA)"
  type        = string
  default     = "HEAD"
}

variable "chart_path" {
  description = "Path inside the repo to the Helm chart"
  type        = string
  default     = "k8s/helm-charts/flask-app"
}

variable "flask_app_namespace" {
  description = "Kubernetes namespace where the Flask app will be deployed"
  type        = string
}
