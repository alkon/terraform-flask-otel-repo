variable "otel_collector_type" {
  description = "The type of OpenTelemetry collector config to use (metrics | logs)"
  type        = string
  default     = "metrics"
}