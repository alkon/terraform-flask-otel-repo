resource "helm_release" "quakewatch" {
  name       = var.chart_name
  repository = var.chart_repo
  chart      = var.chart_name
  version    = var.chart_version

  set {
    name  = "image.repository"
    value = var.image_repository
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }
}
