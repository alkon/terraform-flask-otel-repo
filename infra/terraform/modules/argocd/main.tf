resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# Deploys Argo CD Server
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.1.1"

  create_namespace = false

  values = [
    file("${path.module}/values/values.yaml")
  ]

  # wait            = true      # Waits for all Kubernetes resources to become ready :contentReference[oaicite:1]{index=1}
  # atomic          = true      # On failure, roll back and purge partial installs :contentReference[oaicite:2]{index=2}
  # cleanup_on_fail = true      # Deletes newly created resources if install fails :contentReference[oaicite:3]{index=3}


  timeout = 600 # 10 minutes (in seconds)

  depends_on = [kubernetes_namespace.argocd]
}

# The native ArgoCD resource
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

  depends_on = [helm_release.argocd]
}

# Data source to retrieve the ArgoCD initial admin password from the Kubernetes secret
data "kubernetes_secret" "argocd_admin_password" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argocd.metadata[0].name
  }

  # Ensure we only try to read this secret after the Helm chart has created it
  depends_on = [helm_release.argocd]
}

# Decode the password outside of Terraform's functions
# to avoid UTF-8 errors from random binary data.
data "external" "argocd_admin_password_decoded" {
  program = [
    "sh",
    "-c",
    "kubectl get secret argocd-initial-admin-secret -n argocd -o json | jq -r '.data.password' | base64 --decode | jq -Rns '{password: .}'"
  ]

  # Ensure the secret exists before we try to read it
  depends_on = [helm_release.argocd]
}



