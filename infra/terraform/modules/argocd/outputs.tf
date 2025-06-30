output "argocd_namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_server_node_port" {
  description = "The NodePort for the ArgoCD server service."
  value       = data.kubernetes_service.argocd_server.spec.0.port.0.node_port
}

# Export the decoded admin password from the secret
output "argocd_admin_password" {
  description = "The decoded initial admin password for ArgoCD."
  # Get the password from the external data source's result map
  value       = data.external.argocd_admin_password_decoded.result.password
  sensitive   = true # Mask the value
}

output "flask_app_name" {
  description = "The name of the Argo CD application resource, if created."
  # Use a conditional expression to check if the resource was created.
  # length() returns the number of instances created (0 or 1).
  value = length(argocd_application.flask_app) > 0 ? argocd_application.flask_app[0].metadata[0].name : null
}