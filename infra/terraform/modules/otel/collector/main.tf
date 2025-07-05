terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# Install OpenTelemetry Collector
resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  version    = "0.127.1"

  namespace        = "otel-collector-ns"
  create_namespace = true

  # values = [file("${path.module}/values/collector-config-test.yaml")]

  values = [
    templatefile("collector-config.yaml.tpl", {
      thanos_remote_write_endpoint = var.thanos_remote_write_endpoint
    })
  ]
}

# This service exposes the internal debug and health endpoint (:13133)
# of the OpenTelemetry Collector for observability and troubleshooting.
#
# Purpose:
# - Allows port-forwarding access to /debug/metrics and /debug/tracez
#   which expose live internal telemetry from the collector:
#     • receiver_accepted_metric_points
#     • exporter_sent_metric_points
#     • queue sizes, dropped data, errors, etc.
#
# Why this matters:
# - These endpoints are critical when diagnosing:
#     • Whether metrics are flowing through pipelines
#     • Whether exporters (e.g. prometheusremotewrite) are working
#     • If throttling, batching, or memory limits are affecting throughput
#
# The Helm chart does not expose this port by default, and the official chart schema
# does not allow defining custom service ports. Therefore, we expose this
# via a separate Kubernetes Service resource.
resource "kubernetes_service" "otel_collector_debug" {
  metadata {
    name      = "otel-collector-debug"
    namespace = "otel-collector-ns"
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = "opentelemetry-collector"
    }

    port {
      name        = "health"
      port        = 13133
      target_port = 13133
    }
  }

  depends_on = [helm_release.otel_collector]
}

# New Kubernetes Service to expose OpenTelemetry Collector's Prometheus metrics endpoint
resource "kubernetes_service" "otel_collector_metrics" {
  metadata {
    name      = "otel-collector-metrics"
    namespace = helm_release.otel_collector.namespace
    labels = {
      "app.kubernetes.io/name"      = "opentelemetry-collector"
      "app.kubernetes.io/component" = "standalone-collector"
      # Ensure these labels match the labels on the collector pods for the selector to work
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/name"      = "opentelemetry-collector"
      "app.kubernetes.io/component" = "standalone-collector"
      # These selectors must match the labels on thecollector pods
    }
    port {
      name        = "prometheus-metrics"
      protocol    = "TCP"
      port        = 8889
      target_port = 8889
    }
    type = "ClusterIP"
  }
}
