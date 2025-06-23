resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

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

resource "kubectl_manifest" "flask_app" {
  yaml_body = local.flask_app_manifest_yaml

  depends_on = [helm_release.argocd]
}

