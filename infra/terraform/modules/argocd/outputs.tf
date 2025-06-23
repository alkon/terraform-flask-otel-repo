output "argocd_namespace" {
  value = kubernetes_namespace.argocd.metadata[0].name
}

output "flask_app_manifest_yaml" {
  value = local.flask_app_manifest_yaml
}