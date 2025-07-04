data "kubernetes_service" "argocd_server" {
  depends_on = [helm_release.argocd]
  metadata {
    name      = "argocd-server"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }
}