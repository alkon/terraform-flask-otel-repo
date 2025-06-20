resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = local.effective_namespace_name # Using the local value
    labels = {
      "app.kubernetes.io/name" = var.app_name_prefix
      "managed-by"             = "terraform"
    }
  }
}

resource "kubernetes_service_account" "app_service_account" {
  metadata {
    name      = "${var.app_name_prefix}-sa"
    namespace = kubernetes_namespace.app_namespace.metadata[0].name
    labels = {
      "app.kubernetes.io/name" = var.app_name_prefix
      "managed-by"             = "terraform"
      # Merge additional labels if variable added for them
      # Optional: merge(var.additional_labels, { ... })
    }
  }
}