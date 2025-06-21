# data "kubernetes_namespace" "existing_namespace" {
#   metadata {
#     name = local.effective_namespace_name
#   }
# }
data "kubernetes_namespace" "existing" {
  metadata {
    name = var.namespace_name
  }
}