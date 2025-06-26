locals {
  collector_config_file = var.otel_collector_type == "logs" ? "${path.module}/values/collector-config-logs.yaml" : "${path.module}/values/collector-config-metrics.yaml"
}
