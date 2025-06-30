# Kubernetes Deployment for the Flask Application
resource "kubernetes_deployment" "flask_app_deployment" {
  metadata {
    name      = "flask-app"
    namespace = var.namespace
    labels = {
      app = var.app_label
    }
  }

  spec = yamldecode(templatefile("${path.module}/kubernetes_manifests/deployment_spec.yaml.tpl", {
    image_name            = var.image_name
    image_tag             = var.image_tag
    namespace             = var.namespace
    replicas              = var.replicas
    app_label             = var.app_label
    container_port        = var.container_port
    environment_variables = var.environment_variables
  }))

  depends_on = [
    kubernetes_namespace.app_namespace
  ]
}

# Kubernetes Service for the Flask Application
resource "kubernetes_service" "flask_app_service" {
  metadata {
    name      = "flask-app"
    namespace = var.namespace
    labels = {
      app = var.app_label
    }
  }
  # The 'spec' block is generated from the YAML template file
  spec = yamldecode(templatefile("${path.module}/kubernetes_manifests/service_spec.yaml.tpl", {
    app_label      = var.app_label
    service_port   = var.service_port
    container_port = var.container_port
    service_type   = var.service_type
  }))

  depends_on = [
    kubernetes_namespace.app_namespace
  ]
}
