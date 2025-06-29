output "namespace" {
  description = "The Kubernetes namespace where the OpenTelemetry Collector is deployed."
  value = helm_release.otel_collector.namespace
}
