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
      endpoint: "${prometheus_remote_write_endpoint}" # <-- This is now a template variable
      tls:
        insecure_skip_verify: true
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
          - prometheusremotewrite
          - debug
      traces:
        receivers:
          - otlp
        processors:
          - memory_limiter
          - batch
        exporters:
          - debug