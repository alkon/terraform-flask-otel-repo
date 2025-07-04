resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Deploy Argo CD Server
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.1.1"

  namespace  = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false # Already created

  values = [file("${path.module}/values/values.yaml")]
  timeout = 600 # seconds

  depends_on = [kubernetes_namespace.argocd]
}

# Deploy Argo CD app
resource "argocd_application" "flask_app" {
  count = var.enable_argocd_application ? 1 : 0

  metadata {
    name      = var.flask_app_name
    namespace = "argocd"

    # Experiment to test TF GitOps Engine
    annotations = {
      "managed-by" = "terraform"
      "experiment-id" = "001"
    }
  }

  spec {
    project = "default"

    source {
      repo_url         = var.repo_url
      target_revision  = var.repo_revision
      path             = var.chart_path
      helm {
        values = yamlencode(var.flask_app_helm_values)
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.flask_app_namespace
    }

    sync_policy {
      automated {
        prune     = true
        self_heal = true
      }
    }
  }

  depends_on = [null_resource.wait_for_argocd_api] #[helm_release.argocd]
}

resource "null_resource" "wait_for_argocd_api" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for Argo CD API to become reachable..."
      for i in {1..30}; do
        curl -k --silent --fail http://localhost:30080/version && exit 0
        echo "Still not reachable... retrying in 5s"
        sleep 5
      done
      echo "Timed out waiting for Argo CD" >&2
      exit 1
    EOT
  }
}



