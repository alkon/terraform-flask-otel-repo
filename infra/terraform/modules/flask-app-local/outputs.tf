# Outputs for the Flask Application Local Module
output "app_namespace" {
  description = "The Kubernetes namespace where the Flask application is deployed."
  value       = var.namespace
}

output "app_service_name" {
  description = "The name of the Kubernetes Service for the Flask application."
  value       = kubernetes_service.flask_app_service.metadata[0].name
}

output "app_service_cluster_ip" {
  description = "The ClusterIP of the Flask application service."
  value       = kubernetes_service.flask_app_service.spec[0].cluster_ip
}
