variable "app_namespace" {
  description = "The Kubernetes namespace where the Flask application will be deployed."
  type        = string
}

variable "collector_namespace" {
  description = "The Kubernetes namespace where the OpenTelemetry Collector is deployed. Used for the Instrumentation endpoint."
  type        = string
}

variable "image_name" {
  description = "The name of the Flask application's Docker image."
  type        = string
  default     = "your-flask-app-image" # Placeholder: Replace with your actual image name
}

variable "image_tag" {
  description = "The tag of the Flask application's Docker image."
  type        = string
  default     = "latest" # Placeholder: Replace with your actual image tag
}

variable "create_namespace" {
  description = "Set to true to create the Kubernetes namespace for the application within this module. Set to false if the namespace is managed externally."
  type        = bool
  default     = true
}

variable "helm_chart_config" {
  description = "Configuration for Helm chart deployment."
  type = object({
    chart      = string
    version    = string
    repository = optional(string) # For traditional helm repo add
    source     = optional(string) # For OCI source (e.g., "oci://registry-1.docker.io/bitnami/charts/my-app")
    values_file = optional(string) # Path to values file relative to TF root (e.g., "charts/my-app/values.yaml")
    values     = optional(map(any), {}) # Inline values for the Helm chart
  })

}
