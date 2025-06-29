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

# Install cert-manager (needed for otel-operator)
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.18.1"
  namespace  = "cert-manager"

  create_namespace = true

  # Ensure Helm does not try to re-apply CRDs if they exist
  # skip_crds = true

  # Allows Helm to manage the CRDs, with
  # skip_crds = false (the default)

  set {
    name  = "installCRDs"
    value = "true"
  }

  # Optional: prevent upgrade until CRDs manually handled
  lifecycle {
    ignore_changes = [set]
  }
}
