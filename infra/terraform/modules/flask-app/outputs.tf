output "app_namespace" {
  description = "The Kubernetes namespace where the Flask application Helm chart is deployed."
  value       = var.namespace
}

output "helm_release_name" {
  description = "The name of the Helm release for the Flask application."
  value       = helm_release.flask_app_helm_release.name
}

output "helm_release_version" {
  description = "The version of the Helm release for the Flask application."
  value       = helm_release.flask_app_helm_release.version
}
