resource "kubernetes_namespace" "app_namespace" {
  # 'count' is a built-in Terraform meta-argument (a reserved keyword)
  # used to control how many instances of a resource (or module) Terraform creates:
  # count = N -> create N resources

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
