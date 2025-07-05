variable "flask_app_name" {
  type        = string
}

variable "repo_url" {
  type        = string
}

variable "repo_revision" {
  type        = string
  default     = "HEAD"
}

variable "chart_path" {
  type        = string
}

variable "flask_app_namespace" {
  type        = string
}

variable "flask_app_helm_values" {
  type        = any
  default     = {}
}
