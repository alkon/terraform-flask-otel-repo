# Install OpenTelemetry Collector
resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  namespace  = "default"
  version    = "0.127.1"

  depends_on = [helm_release.otel_operator]

  set {
    name  = "image.repository"
    value = "otel/opentelemetry-collector-contrib"
  }

  set {
    name  = "image.tag"
    value = "0.128.0"
  }

  set {
    name  = "mode"
    value = "deployment" # or "daemonset", depending on your case
  }

  values = [
    file(local.collector_config_file)
  ]

  # values = [
  #   file("${path.module}/values/collector-config.yaml")
  # ]
}