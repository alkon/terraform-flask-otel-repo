resource "helm_release" "flask_app_helm_release" {
  name             = "flask-app-helm" # A distinct name for the Helm release
  namespace        = var.namespace
  create_namespace = false # Namespace is managed by this module's kubernetes_namespace resource or externally

  chart   = var.helm_chart_config.chart
  version = var.helm_chart_config.version

  dynamic "repository" {
    for_each = var.helm_chart_config.repository != null ? [var.helm_chart_config.repository] : []
    content {
      value = repository.value
    }
  }

  dynamic "source" {
    for_each = var.helm_chart_config.source != null ? [var.helm_chart_config.source] : []
    content {
      value = source.value
    }
  }

  values = concat(
    var.helm_chart_config.values_file != null ? [file("${path.root}/${var.helm_chart_config.values_file}")] : [],
    [yamlencode(var.helm_chart_config.values)]
  )

  depends_on = [
    kubernetes_namespace.app_namespace
  ]
}
