resource "helm_release" "redis" {
  name       = "redis"
  namespace  = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = " 21.2.5"

  create_namespace = true

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "auth.enabled"
    value = "false" # Simplify for local testing
  }
}
