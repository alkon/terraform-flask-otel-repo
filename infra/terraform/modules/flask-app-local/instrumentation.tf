# OpenTelemetry Instrumentation Custom Resource
resource "kubernetes_manifest" "instrumentation_flask" {
  manifest = yamldecode(templatefile("${path.root}/instrumentation/flask-app.yaml", {
    app_namespace        = var.namespace
    collector_namespace  = var.collector_namespace
    instrumentation_name = "flask-auto-instrumentation"
  }))

  depends_on = [
    kubernetes_namespace.app_namespace
  ]
}
