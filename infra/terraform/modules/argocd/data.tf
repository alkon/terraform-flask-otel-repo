# Look up the service created by the Helm chart to get its NodePort
data "kubernetes_service" "argocd_server" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "argocd-server" # This is the standard service name from the Helm chart
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
}