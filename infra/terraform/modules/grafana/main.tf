resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "9.2.7"

  values = [
    templatefile("${path.module}/values/datasources.yaml.tpl", {
      prometheus_url = var.prometheus_url
    })
  ]

  set {
    name  = "adminPassword"
    value = "admin" # Optional: set secure password
  }

  create_namespace = false
}
