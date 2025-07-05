variable "otel_collector_type" {
  description = "The type of OpenTelemetry collector config to use (metrics | logs)"
  type        = string
  default     = "metrics"
}

# variable "prometheus_remote_write_endpoint" {
#   description = "The full URL for the Prometheus remote write endpoint."
#   type        = string
# }

variable "thanos_remote_write_endpoint" {
  description = "The full URL for the Thanos remote write endpoint."
  type        = string
}

