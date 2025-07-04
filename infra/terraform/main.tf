# --- Module Deployments ---

# 1. Cert-Manager (for TLS certificates)
module "cert_manager" {
  source = "./modules/cert-manager"
}

# 2. OpenTelemetry Operator (for auto-instrumentation)
module "otel_operator" {
  source = "./modules/otel/operator"

  depends_on = [null_resource.wait_for_cert_manager_webhook]
}

# 3. Thanos (Metrics Receiver and Query)
module "thanos" {
  source = "./modules/thanos"
  depends_on = [
    module.otel_operator # Thanos Receiver depends on Operator for namespace
  ]
}

# 4. OpenTelemetry Collector (receives and exports telemetry)
module "otel_collector" {
  source = "./modules/otel/collector"
  depends_on = [
    module.otel_operator,
    module.thanos # OTel Collector depends on Thanos Receiver being ready
  ]

  # Update endpoint to point to Thanos Receiver using the new variable name
  # thanos_remote_write_endpoint = "http://thanos-receiver.thanos-ns.svc.cluster.local:19291/api/v1/receive"
  thanos_remote_write_endpoint = "http://thanos-receiver-receive.thanos-ns.svc.cluster.local:19291/api/v1/receive" # <-- CRITICAL CHANGE
}

# 5. Prometheus (metrics backend - for other scrapes) - DISABLED FOR NOW
# module "prometheus" {
#   source = "./modules/prometheus"
# }

# 6. Grafana (visualization dashboard)
module "grafana" {
  source = "./modules/grafana"
  # Pass the Thanos Query service endpoint to Grafana using the new variable name
  thanos_query_url = "http://thanos-query-query.thanos-ns.svc.cluster.local:9090" # <-- CRITICAL CHANGE

  depends_on = [
    module.thanos # Grafana now depends on Thanos Query being ready
  ]
}

# Test module
module "flask_app_test" {
  source = "./modules/flask-test"

  namespace = "flask-app-ns"

  depends_on = [
    module.otel_operator,
    module.otel_collector
  ]
}

# 7. ArgoCD Server
module "argocd_server" {
  source = "./modules/argocd-server"

  providers = {
    kubernetes = kubernetes
    helm       = helm
    kubectl    = kubectl
  }
}

# 8. ArgoCD app
module "argocd_app" {
  source = "./modules/argocd-app"
  providers = {argocd = argocd.main}

  depends_on = [
    null_resource.wait_for_argocd_api,
    module.otel_collector,
    module.grafana,
    kubernetes_namespace.flask_app_namespace
  ]

  repo_url              = "https://github.com/${var.github_repo_owner}/${var.git_repo_name}.git"
  repo_revision         = "HEAD"
  chart_path            = "k8s/helm-charts/flask-app"
  flask_app_name        = var.helm_chart_name
  flask_app_namespace   = var.flask_app_namespace
  flask_app_helm_values = local.flask_app_helm_values
}