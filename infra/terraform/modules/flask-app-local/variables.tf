# ==============================================================================
# Flask Application Local Module Configuration Variables
# (For Kubernetes Manifest Deployments)
# ==============================================================================
variable "namespace" {
  description = "The Kubernetes namespace where the Flask application will be deployed."
  type        = string
}

variable "collector_namespace" {
  description = "The Kubernetes namespace where the OpenTelemetry Collector is deployed. Used for the Instrumentation endpoint."
  type        = string
}

variable "create_namespace" {
  description = "Set to true to create the Kubernetes namespace for the application within this module. Set to false if the namespace is managed externally."
  type        = bool
  default     = true
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

variable "replicas" {
  description = "The number of replicas for the Flask application deployment."
  type        = number
  default     = 1
}

variable "app_label" {
  description = "The value for the 'app' label used for the deployment and service selector."
  type        = string
  default     = "flask-app"
}

variable "container_port" {
  description = "The port on which the Flask application container listens."
  type        = number
  default     = 5000
}

variable "service_port" {
  description = "The port on which the Kubernetes Service will be exposed."
  type        = number
  default     = 80
}

variable "service_type" {
  description = "The type of Kubernetes Service to create (e.g., ClusterIP, NodePort, LoadBalancer)."
  type        = string
  default     = "ClusterIP"
}

variable "environment_variables" {
  description = "A map of environment variables to set in the Flask application container."
  type        = map(string)
  default     = {
    FLASK_APP = "app.py" # Default Flask app entry point
  }
}
