# Special resource: wait for the OTel Operator's CRDs to be available
/*
resource "null_resource" "wait_for_otel_crds" {
  provisioner "local-exec" {
    command = templatefile("${path.root}/scripts/wait_for_k8s_crd.sh.tpl", {
      crd_name               = "instrumentations.opentelemetry.io"
      timeout_seconds        = 60
      sleep_interval_seconds = 2
    })
  }

  depends_on = [module.otel_operator]
}
*/

resource "null_resource" "wait_for_argocd_api" {

  provisioner "local-exec" {
    command = <<EOT
    echo "Waiting for argocd-server pod to be Ready using kubectl wait..."

    # Replace 'argocd' with the actual namespace your Argo CD server is deployed in
    # Replace 'app.kubernetes.io/name=argocd-server' with the exact selector for your Argo CD server pod
    kubectl wait --for=condition=ready pod --selector=app.kubernetes.io/name=argocd-server -n argocd --timeout=180s

    if [ $? -eq 0 ]; then
      echo "argocd-server pod is Ready."
    else
      echo "Timed out or failed waiting for argocd-server pod to become Ready." >&2
      exit 1
    fi
    EOT
  }
}

# A special resource to wait for the cert-manager webhook pods to be ready
resource "null_resource" "wait_for_cert_manager_webhook" {
  provisioner "local-exec" {
    # We will use a while loop with a retry logic to wait for the webhook pods.
    # We wait for the pods to exist first, then wait for them to be ready.
    command = <<EOT
      set -e # Exit immediately if a command exits with a non-zero status

      echo "Waiting for cert-manager webhook pods to be created..."
      TIMEOUT=120
      SLEEP_TIME=5
      START_TIME=$(date +%s)
      while true; do
        if kubectl get pods -l app.kubernetes.io/component=webhook -n cert-ns | grep "webhook"; then
          echo "Webhook pods found. Waiting for readiness..."
          # Wait for the pods to be ready (up to 300s as in your original command)
          kubectl wait --for=condition=ready pod --selector=app.kubernetes.io/component=webhook -n cert-ns --timeout=300s
          break
        fi

        CURRENT_TIME=$(date +%s)
        if [ $((CURRENT_TIME - START_TIME)) -ge $TIMEOUT ]; then
          echo "Timeout waiting for webhook pods to appear."
          exit 1
        fi

        echo "Pods not found yet. Retrying in $SLEEP_TIME seconds..."
        sleep $SLEEP_TIME
      done
    EOT
  }

  # Ensure the cert-manager application has been created by ArgoCD before executing kubectl wait
  depends_on = [module.argocd_app_cert_manager]
}



# resource "null_resource" "wait_for_cert_manager_webhook" {
#   provisioner "local-exec" {
#     # Use a kubectl command to wait for the pods with a specific label ('cert-manager')
#     command = "kubectl wait --for=condition=ready pod --selector=app.kubernetes.io/component=webhook -n cert-ns --timeout=300s"
#   }
#
#   # Wait for cert_manager module to be deployed first
#   depends_on = [module.argocd_app_cert_manager]
# }

/*
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
*/


# resource "null_resource" "wait_for_argocd_api" {
#   provisioner "local-exec" {
#     command = <<EOT
# echo "Waiting for argocd-server pod to be Ready..."
#
# for i in {1..30}; do
#   READY=$(kubectl get pod -n argocd -l app.kubernetes.io/name=argocd-server -o jsonpath="{.items[0].status.containerStatuses[0].ready}")
#   if [ "$READY" = "true" ]; then
#     echo "argocd-server pod is Ready."
#     exit 0
#   fi
#   echo "Attempt $i: pod not ready yet, retrying in 5s..."
#   sleep 5
# done
#
# echo "Timed out waiting for argocd-server pod to become Ready." >&2
# exit 1
# EOT
#   }
# }






