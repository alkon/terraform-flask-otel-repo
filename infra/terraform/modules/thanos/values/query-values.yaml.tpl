query:
  enabled: true # Enable the Query component
  replicaCount: 1 # Start with 1 replica
  stores:
    - ${thanos_receiver_grpc_endpoint} # Passed from Terraform template
  service:
    type: ClusterIP
    ports:
      http: 9090 # Default HTTP port for the Query UI and PromQL API
      grpc: 10901 # Default gRPC port for internal communication

  # Resources for the Query pod
  resources:
    requests:
      cpu: "200m"
      memory: "512Mi"
    limits:
      cpu: "1"
      memory: "1Gi"

# Explicitly disable all other Thanos components for this release
receiver:
  enabled: false
queryFrontend:
  enabled: false
storegateway:
  enabled: false
compactor:
  enabled: false
ruler:
  enabled: false
bucketweb:
  enabled: false
memcached:
  enabled: false
memcachedExporter:
  enabled: false