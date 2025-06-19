# Install cert-manager (needed for otel-operator)
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  version    = "v1.14.4"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

# Install OpenTelemetry Operator
resource "helm_release" "otel_operator" {
  name       = "opentelemetry-operator"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-operator"
  namespace  = "default"
  version    = "0.43.0"

  depends_on = [helm_release.cert_manager]
}

# Install OpenTelemetry Collector
resource "helm_release" "otel_collector" {
  name       = "otel-collector"
  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  chart      = "opentelemetry-collector"
  namespace  = "default"
  version    = "0.84.0"

  depends_on = [helm_release.otel_operator]

  set {
    name  = "image.repository"
    value = "otel/opentelemetry-collector"
  }
}

# Delay Instrumentation CR until CRD is available
resource "null_resource" "wait_for_otel_crds" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for Instrumentation CRD to be ready..."
      for i in {1..30}; do
        kubectl get crd instrumentations.opentelemetry.io && exit 0
        sleep 2
      done
      echo "Instrumentation CRD not found after 60s" >&2
      exit 1
EOT
  }

  depends_on = [helm_release.otel_operator]
}

# Define auto-instrumentation for Flask app
resource "kubectl_manifest" "instrumentation" {
  yaml_body = <<YAML
apiVersion: opentelemetry.io/v1alpha1
kind: Instrumentation
metadata:
  name: flask-auto
  namespace: default
spec:
  exporter:
    endpoint: http://otel-collector:4317
  propagators:
    - tracecontext
    - baggage
  sampler:
    type: parentbased_always_on
  python:
    image: ghcr.io/open-telemetry/opentelemetry-operator/autoinstrumentation-python:latest
YAML

  depends_on = [null_resource.wait_for_otel_crds]
}
