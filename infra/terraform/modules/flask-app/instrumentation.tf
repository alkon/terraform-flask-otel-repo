resource "kubernetes_manifest" "instrumentation_flask" {
  manifest = yamldecode(templatefile("${path.root}/instrumentation/flask-app.yaml", {
    app_ns               = var.app_namespace
    collector_ns         = var.collector_namespace
    instrumentation_name = "flask-auto-instrumentation"
  }))

  depends_on = [
    kubernetes_namespace.app_namespace
  ]
}
