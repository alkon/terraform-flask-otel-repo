output "namespace" {
  description = "Namespace where the OpenTelemetry operator is deployed"
  value       = helm_release.otel_operator.namespace
}