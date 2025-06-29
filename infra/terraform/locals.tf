locals {
  flask_app_helm_values = {
    image = {
      repository = "${var.docker_image_repo}/${var.github_repo_owner}/${var.helm_chart_name}"
      tag        = var.docker_image_tag
    }
    opentelemetry = {
      enabled           = true
      collectorEndpoint = "http://otel-collector-opentelemetry-collector.${module.otel_collector.namespace}.svc.cluster.local:4317"
      protocol          = "grpc"
      serviceName       = var.flask_app_service_name
      resourceAttributes = {
        "service.version" = var.docker_image_tag
      }
      environmentVariables = {}
    }
    # Inject this special annotation into the pod template in the Helm chart via ArgoCD
    # This is done to help OTel Operator to inject the its special environment variables
    # Explanation: in the charts 'k8s/helm-charts/flask-app/templates/deployment.yaml'
    # already exists as metadata.podAnnotations; simply use it
    podAnnotations = {
      "opentelemetry.io/instrumentation" = "flask-auto-instrumentation"
    }
  }
}