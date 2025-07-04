resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "9.2.7"

  values = [
    templatefile("${path.module}/values/datasources.yaml.tpl", {
      thanos_query_url = var.thanos_query_url
    })
  ]

  create_namespace = true
}