locals {
  otel_namespace_name   = kubernetes_namespace.otel_ns.metadata[0].name
  thanos_namespace_name = kubernetes_namespace.thanos_ns.metadata[0].name
  monitoring_namespace_name = kubernetes_namespace.monitoring.metadata[0].name
  cert_namespace_name = kubernetes_namespace.cert_ns.metadata[0].name
  flask_app_namespace_name = kubernetes_namespace.flask_app_ns.metadata[0].name

  # argocd_provider_config = {
  #   server_addr = var.argocd_server
  #   username    = var.argocd_username
  #   password    = var.argocd_password
  #   insecure    = var.argocd_insecure
  #   grpc_web    = false
  # }

  /*
  otel_instrumentation_values = {
    enabled           = true
    collectorEndpoint = "http://otel-collector-opentelemetry-collector.${module.otel_collector.namespace}.svc.cluster.local:4317"
    protocol          = "grpc"
    serviceName       = var.flask_app_service_name
    resourceAttributes = {
      "service.version" = var.docker_image_tag
    }
    environmentVariables = {}
  }

  flask_app_helm_values = {
    image = {
      repository = "${var.docker_image_repo}/${var.github_repo_owner}/${var.helm_chart_name}"
      tag        = var.docker_image_tag
    }
    opentelemetry = local.otel_instrumentation_values

    podAnnotations = {
      "opentelemetry.io/instrumentation" = "${module.otel_operator.namespace}/flask-auto-instrumentation"
    }
  }

  */
}