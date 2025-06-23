output "namespace_name" {
  value = try(kubernetes_namespace.app_namespace.metadata[0].name, local.effective_namespace_name)
}

# output "service_account_name" {
#   description = "The name of the created Kubernetes Service Account."
#   value       = kubernetes_service_account.app_service_account.metadata[0].name
# }
