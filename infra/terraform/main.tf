# --- Module Deployments ---

# 1. Cert-Manager (for TLS certificates)
module "cert_manager" {
  source = "./modules/cert-manager"
}

# 2. OpenTelemetry Operator (for auto-instrumentation)
module "otel_operator" {
  source = "./modules/otel/operator"

  depends_on = [
    null_resource.wait_for_cert_manager_webhook
  ]
}

# 3. OpenTelemetry Collector (receives and exports telemetry)
module "otel_collector" {
  source = "./modules/otel/collector"
  depends_on = [
    module.otel_operator # Ensure the operator is ready
  ]
  # Using the full FQDN as you prefer
  prometheus_remote_write_endpoint = "http://${module.prometheus.service_name}.${module.prometheus.namespace}.svc.cluster.local:${module.prometheus.remote_write_port}/api/v1/write"
}

# 4. Prometheus (metrics backend)
module "prometheus" {
  source = "./modules/prometheus"
}

# 5. Grafana (visualization dashboard)
module "grafana" {
  source = "./modules/grafana"
  # Pass the Prometheus service endpoint to Grafana
  prometheus_url = "http://${module.prometheus.service_name}.${module.prometheus.namespace}.svc.cluster.local:${module.prometheus.remote_write_port}"
  depends_on = [
    module.prometheus
  ]
}

# 6. ArgoCD (GitOps tool)
module "argocd" {
  source = "./modules/argocd"

  # Pass the value from the root module's variable to the child module's variable
  enable_argocd_application = var.enable_argocd_application

  # Pass Flask app details for ArgoCD Application manifest
  flask_app_name      = var.helm_chart_name
  repo_url            = "https://github.com/${var.github_repo_owner}/${var.git_repo_name}.git"
  repo_revision       = "HEAD" # This can be dynamic from CI/CD
  chart_path          = "k8s/helm-charts/flask-app"
  flask_app_namespace = var.flask_app_namespace
  # Pass dynamic Helm values for the Flask app to ArgoCD
  flask_app_helm_values = local.flask_app_helm_values

  depends_on = [
    module.otel_collector,
    module.grafana,
    # Ensure the Flask app's namespace exists before deploying the ArgoCD's Application manifest
    kubernetes_namespace.flask_app_namespace,
  ]
}

