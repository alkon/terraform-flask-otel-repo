resource "kubernetes_namespace" "app_namespace" {
  count = var.create_namespace ? 1 : 0 # Conditionally create the namespace
  metadata {
    name = var.namespace
  }
}