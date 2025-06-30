locals {
  loki_values = templatefile("${path.module}/templates/loki-values.tmpl.yaml", {})
}