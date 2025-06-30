# Special resource: wait for the OTel Operator's CRDs to be available
resource "null_resource" "wait_for_otel_crds" {
  provisioner "local-exec" {
    command = templatefile("${path.root}/scripts/wait_for_k8s_crd.sh.tpl", {
      crd_name               = "instrumentations.opentelemetry.io"
      timeout_seconds        = 60
      sleep_interval_seconds = 2
    })
  }

  # Ensure the OTel Operator module is deployed
  depends_on = [
    module.otel_operator
  ]
}

resource "kubernetes_namespace" "flask_app_namespace" {
  metadata {
    name = var.flask_app_namespace
  }
}

resource "kubectl_manifest" "instrumentation_flask" {
  yaml_body = templatefile("${path.module}/instrumentation/flask-app.yaml", {
    instrumentation_name = "flask-auto-instrumentation"
    app_ns               = var.flask_app_namespace
    collector_ns         = module.otel_collector.namespace
    otel_service_name    = var.flask_app_service_name
  })

  depends_on = [
    null_resource.wait_for_otel_crds,
    module.otel_collector,
    kubernetes_namespace.flask_app_namespace
  ]
}

# A special resource to wait for the cert-manager webhook pods to be ready
resource "null_resource" "wait_for_cert_manager_webhook" {
  provisioner "local-exec" {
    # Use a kubectl command to wait for the pods with a specific label ('cert-manager')
    command = "kubectl wait --for=condition=ready pod --selector=app.kubernetes.io/component=webhook -n cert-manager --timeout=300s"
  }

  # This waiter depends on the cert_manager module to ensure it's been deployed first
  depends_on = [
    module.cert_manager
  ]
}

