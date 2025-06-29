output "service_name" {
  description = "The name of the Prometheus server service."
  # Bitnami chart naming convention is <release_name>-<chart_name>
  value = "${helm_release.prometheus.name}-${helm_release.prometheus.chart}"
}

output "namespace" {
  description = "The namespace where Prometheus is deployed."
  value       = helm_release.prometheus.namespace
}

output "remote_write_port" {
  description = "The port for the Prometheus remote write endpoint."
  # Fixed port based on the Bitnami chart's defaults.
  value = 9090
}