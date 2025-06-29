# Lightweight Prometheus server for metric storage (Bitnami)
resource "helm_release" "prometheus" {
  name  = "prometheus"
  chart = "oci://registry-1.docker.io/bitnamicharts/prometheus"
  version    = "2.1.9"

  namespace        = "monitoring"
  create_namespace = true

  timeout = 600

  # This values file is compatible with Bitnami's chart
  values = [
    file("${path.module}/values/values.yaml")
  ]
}