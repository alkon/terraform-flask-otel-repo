# Install cert-manager (needed for otel-operator)
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.18.1"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# Install OpenTelemetry Operator
# resource "helm_release" "otel_operator" {
#   name       = "opentelemetry-operator"
#   repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
#   chart      = "opentelemetry-operator"
#   namespace  = "default"
#   version    = "0.43.0"
#
#   depends_on = [helm_release.cert_manager]
# }

# Install OpenTelemetry Operator
resource "helm_release" "otel_operator" {
  name       = "opentelemetry-operator"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-operator"
  namespace  = "default"
  version    = "0.90.3"

  depends_on = [helm_release.cert_manager]

  set {
    name  = "manager.image.repository"
    value = "ghcr.io/open-telemetry/opentelemetry-operator/opentelemetry-operator"
  }

  set {
    name  = "manager.image.tag"
    value = "0.126.0"
  }

  set {
    name  = "admissionWebhooks.certManager.enabled"
    value = "true"
  }

  # set {
  #   name  = "createCRDs"
  #   value = "true"
  # }
}


# Install OpenTelemetry Collector
resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  namespace  = "default"
  version    = "0.127.1"

  depends_on = [helm_release.otel_operator]

  set {
    name  = "image.repository"
    value = "otel/opentelemetry-collector-contrib"
  }

  set {
    name  = "image.tag"
    value = "0.128.0"
  }

  set {
    name  = "mode"
    value = "deployment" # or "daemonset", depending on your case
  }

  values = [
    file("${path.module}/values/collector-config.yaml")
  ]

}

# Delay Instrumentation CR until CRD is available
resource "null_resource" "wait_for_otel_crds" {
  provisioner "local-exec" {
    command = templatefile("${path.root}/scripts/wait_for_k8s_crd.sh.tpl", {
      # Pass arguments to the script using Terraform's list syntax for command-line args
      crd_name               = "instrumentations.opentelemetry.io"
      timeout_seconds        = 60 # Original 30 attempts * 2 seconds = 60 seconds
      sleep_interval_seconds = 2
    })
  }

  # This dependency is critical: it ensures the OTel Operator (which creates the CRD) and Collector
  # are deployed before we start waiting for the CRD.
  depends_on = [
    helm_release.otel_operator,
    helm_release.otel_collector
  ]
}

# Define auto-instrumentation for Flask app
resource "kubectl_manifest" "instrumentation" {
  yaml_body = templatefile("${path.module}/manifests/instrumentation.yaml", {
    instrumentation_name = "flask-auto" # Pass hardcoded value or a variable from otel module
    namespace            = "default"
  })
  depends_on = [null_resource.wait_for_otel_crds]
}
