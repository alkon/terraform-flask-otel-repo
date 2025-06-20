output "namespace_name" {
  description = "The name of the created Kubernetes namespace."
  value       = kubernetes_namespace.app_namespace.metadata[0].name
}

output "service_account_name" {
  description = "The name of the created Kubernetes Service Account."
  value       = kubernetes_service_account.app_service_account.metadata[0].name
}