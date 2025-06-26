# Install cert-manager (needed for otel-operator)
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.18.1"
  namespace  = "cert-manager"

  create_namespace = true

  # Ensure Helm does not try to re-apply CRDs if they exist
  skip_crds = true

  set {
    name  = "installCRDs"
    value = "true"
  }

  # Optional: prevent upgrade until CRDs manually handled
  lifecycle {
    ignore_changes = [set]
  }
}


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
