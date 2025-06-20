variable "app_name_prefix" {
  description = "A prefix for naming Kubernetes resources (e.g., service accounts, namespaces)."
  type        = string
}

variable "namespace_name" {
  description = "The name of the Kubernetes namespace to create. Defaults to app_name_prefix if not set."
  type        = string
  default     = "" # No default, will be set programmatically or at call-site
}
