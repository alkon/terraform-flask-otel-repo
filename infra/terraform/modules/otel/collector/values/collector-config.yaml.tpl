mode: deployment
image:
  repository: otel/opentelemetry-collector-contrib
  tag: 0.128.0
config:
  receivers:
    otlp:
      protocols:
        grpc:
          endpoint: 0.0.0.0:4317
        http:
          endpoint: 0.0.0.0:4318
  exporters:
    debug:
      verbosity: detailed
    prometheusremotewrite:
      endpoint: ${thanos_remote_write_endpoint} # Use the passed variable
      # Convert OTLP metrics into Prometheus-friendly format
      resource_to_telemetry_conversion:
        enabled: true
      tls:
        insecure_skip_verify: true # Keep this for now, adjust if you implement TLS on Thanos Receiver
  processors:
    batch: {}
    memory_limiter:
      check_interval: 5s
      limit_percentage: 80
      spike_limit_percentage: 25
  extensions:
    health_check:
      endpoint: 0.0.0.0:13133
  service:
    extensions:
      - health_check
    pipelines:
      metrics:
        receivers:
          - otlp
        processors:
          - batch
        exporters:
          - prometheusremotewrite # Ensure metrics pipeline uses this exporter
          - debug
      traces:
        receivers:
          - otlp
        processors:
          - memory_limiter
          - batch
        exporters:
          - debug
