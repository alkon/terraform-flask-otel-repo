output "service_name" {
  description = "The name of the Prometheus server service."
  value = "prometheus-server"
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