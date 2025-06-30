resource "helm_release" "loki" {
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  version          = "5.47.2"
  namespace        = "monitoring"
  create_namespace = true

  values = [
    file("${path.module}/templates/loki-values.tmpl.yaml")
  ]

  # Add this 'set' block to override chart values
  set {
    name  = "loki.image.tag"
    value = "2.9.6"
  }
  set {
    name  = "compactor.storage.type"
    value = "filesystem"
  }
  set {
    name  = "ruler.storage.type"
    value = "filesystem"
  }
  set {
    name  = "singleBinary.replicas"
    value = "1"
  }

  #depends_on = [helm_release.minio]
}

# Simulate S3 bucket storage with Bitnami MinIO
/*
resource "helm_release" "minio" {

  name             = "minio"
  repository       = "https://charts.min.io/"
  chart            = "minio"
  version          =  "5.4.0"

  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "accessKey"
    value = "minioadmin" # IMPORTANT: Change this for production environments!
    type  = "string"
  }
  set {
    name  = "secretKey"
    value = "minioadmin" # IMPORTANT: Change this for production environments!
    type  = "string"
  }
  set {
    name  = "image.repository"
    value = "minio/minio"
    type  = "string"
  }
  set {
    name  = "image.tag"
    value = "RELEASE.2024-12-18T13-15-44Z" # Example: choose a recent stable release
  }
  set {
    name  = "mode"
    value = "standalone"
  }
  set {
    name  = "persistence.enabled"
    value = "true" # Enable persistent storage for MinIO data
  }
  set {
    name  = "persistence.size"
    value = "10Gi" # Size of the Persistent Volume Claim (adjust as needed)
  }
  set {
    name  = "persistence.storageClass"
    value = "local-path" # Use your cluster's default storage class (e.g., 'standard', 'gp2', 'azure-disk')
  }
  set {
    name  = "resources.requests.memory"
    value = "1Gi"
  }
  set {
    name  = "resources.limits.memory"
    value = "2Gi"
    type  = "string"
  }
  set {
    name  = "service.type"
    value = "ClusterIP"
  }
  set {
    name  = "service.port"
    value = "9000" # MinIO S3 API port
  }
  set {
    name  = "service.consolePort"
    value = "9001" # MinIO Console (web UI) port
  }
}
 */

