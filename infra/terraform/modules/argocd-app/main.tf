resource "argocd_application" "flask_app" {

  metadata {
    name      = var.flask_app_name
    namespace = "argocd"
    annotations = {
      "managed-by"   = "terraform"
      "experiment-id" = "001"
    }
  }

  spec {
    project = "default"

    source {
      repo_url        = var.repo_url
      target_revision = var.repo_revision
      path            = var.chart_path
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
}
