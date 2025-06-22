resource "helm_release" "flask_app_release" {
  name       = var.helm_chart_name
  namespace  = module.flask_app_infra.namespace_name
  create_namespace = true # Added this back, good practice to ensure namespace exists

  chart = var.use_local_chart ? "${path.module}/../../k8s/helm-charts/flask-app" : var.helm_chart_name

  repository = var.use_local_chart ? null : "${var.helm_chart_repo}/${var.github_repo_owner}"

  version = var.use_local_chart ? null : var.helm_chart_version

  values = var.use_local_chart ? [file("${path.module}/../../k8s/helm-charts/flask-app/values.yaml")] : []

  set {
    name  = "image.repository"
    value = "${var.docker_image_repo}/${var.github_repo_owner}/${var.helm_chart_name}"
  }

  set {
    name  = "image.tag"
    value = var.docker_image_tag
  }

  depends_on = [
    module.otel,             # Ensure OTel infrastructure is ready
    module.flask_app_infra,  # Ensure the target namespace and service account are ready
    null_resource.create_k3d_cluster  # Explicitly depend on the k3d cluster creation
  ]
}