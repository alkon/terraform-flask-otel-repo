data "kubernetes_namespace" "existing" {
  metadata {
    name = var.namespace_name
  }
}