# locals {
#   # This variable now reads the content of the new YAML file and injects the vars.
#   helm_values_yaml = templatefile("${path.module}/templates/helm_values.yaml.tmpl", {
#     helm_values = var.flask_app_helm_values
#   })
#
#   # Correct the path to include the 'templates' subdirectory
#   flask_app_manifest_yaml = templatefile("${path.module}/templates/flask-app.yaml.tmpl", {
#     app_name         = var.flask_app_name
#     repo_url         = var.repo_url
#     revision         = var.repo_revision
#     chart_path       = var.chart_path
#     target_namespace = var.flask_app_namespace
#     helm_values_yaml = local.helm_values_yaml
#   })
# }