terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

# Install OpenTelemetry Operator
resource "helm_release" "otel_operator" {
  name       = "opentelemetry-operator"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  # repository = "oci://ghcr.io/open-telemetry/opentelemetry-helm-charts"
  chart      = "opentelemetry-operator"
  version    = "0.90.4"

  namespace  = "otel-operator-ns"
  create_namespace = true

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