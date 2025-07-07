# Used hostmetrics to generate internal metrics and pushes them to prometheusremotewrite ONLY.
mode: deployment
image:
  repository: otel/opentelemetry-collector-contrib
  tag: 0.128.0

config:
  receivers:
#    hostmetrics:
#      collection_interval: 5s
#      scrapers:
#        cpu:
#        memory:
#        disk:
#        filesystem:
#        network:
#        load:
    otlp:
      protocols:
        grpc: {}
        http: {}

  exporters:
    debug:
      verbosity: detailed
    prometheusremotewrite:
      endpoint: ${thanos_remote_write_endpoint}
      tls:
        insecure_skip_verify: true
      resource_to_telemetry_conversion:
        enabled: true

  processors:
    batch: {}

  extensions:
    health_check:
      endpoint: 0.0.0.0:13133
    pprof:
      endpoint: 0.0.0.0:1777
    zpages:
      endpoint: 0.0.0.0:55679

  service:
    telemetry:
      logs:
        level: debug
      metrics:
        address: 0.0.0.0:8888
    extensions:
      - health_check
      - pprof
      - zpages
    pipelines:
      metrics:
        receivers:
          - otlp
#          - hostmetrics
        processors:
          - batch
        exporters:
          - debug
          - prometheusremotewrite