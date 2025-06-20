resource "helm_release" "flask_app_release" {
  name       = var.helm_chart_name
  # Construct the full OCI repository path: oci://ghcr.io/alkon/flask-app
  repository = "${var.helm_chart_repo}/${var.github_repo_owner}" # <-- FIXED: Concatenation added!
  chart      = var.helm_chart_name
  version    = var.helm_chart_version
  namespace  = module.flask_app_infra.namespace_name
  create_namespace = true # Added this back, good practice to ensure namespace exists

  set {
    name  = "image.repository"
    # Construct the full Docker image repository path: ghcr.io/alkon/flask-app
    value = "${var.docker_image_repo}/${var.github_repo_owner}/${var.helm_chart_name}"
  }

  set {
    name  = "image.tag"
    value = var.docker_image_tag
  }

  # If your Helm chart has a value for serviceAccount.name to use an existing SA,
  # you can pass the one created by the infrastructure module:
  # set {
  #   name  = "serviceAccount.name"
  #   value = module.flask_app_infra.service_account_name
  # }
  # Note: You'll need to disable serviceAccount.create in your chart's values.yaml if using this.

  depends_on = [
    module.otel,           # Ensure OTel infrastructure is ready
    module.flask_app_infra, # Ensure the target namespace and service account are ready
    null_resource.create_k3d_cluster # Explicitly depend on the k3d cluster creation
  ]
}