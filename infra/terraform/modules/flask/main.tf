resource "kubernetes_namespace" "app_namespace" {
  # 'count' is a built-in Terraform meta-argument (a reserved keyword)
  # used to control how many instances of a resource (or module) Terraform creates:
  # count = N -> create N resources
  # count = try(data.kubernetes_namespace.existing_namespace.metadata[0].name, "") != local.effective_namespace_name ? 1 : 0
  # count = try(data.kubernetes_namespace.existing.metadata[0].name, "") == "" ? 1 : 0

  metadata {
    name = local.effective_namespace_name # Using the local value
    labels = {
      "app.kubernetes.io/name" = var.app_name_prefix
      "managed-by"             = "terraform"
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [metadata[0].labels]
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