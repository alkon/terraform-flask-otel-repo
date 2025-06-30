terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

# Install OpenTelemetry Collector
resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.127.1"

  namespace  = "otel-collector-ns"
  create_namespace = true

  # Use templatefile to render the values dynamically
  values = [
    templatefile("${path.module}/values/collector-config.yaml.tpl", {
      prometheus_remote_write_endpoint = var.prometheus_remote_write_endpoint
    })
  ]

  # values = [
  #   file(local.collector_config_file)
  # ]

  # values = [
  #   file("${path.module}/values/collector-config.yaml.tpl")
  # ]
}