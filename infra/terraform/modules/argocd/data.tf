# locals {
#   flask_app_manifest_yaml = templatefile("${path.module}/templates/flask-app.tmpl.yaml", {
#     app_name         = var.flask_app_name
#     repo_url         = var.repo_url
#     revision         = var.repo_revision
#     chart_path       = var.chart_path
#     target_namespace = var.flask_app_namespace
#   })
# }
