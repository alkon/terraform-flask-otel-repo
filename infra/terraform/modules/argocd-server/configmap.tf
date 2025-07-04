# Important! This will overwrite any existing argocd-cm values if they're not included here.
# If there are already have custom SSO, RBAC, etc., merge those in.

### The target: To enable token generation MODIFY the Argo CD ConfigMap (argocd-cm) to allow
### See also restart.tf - comments
# resource "kubernetes_config_map" "argocd_cm" {
#   metadata {
#     name      = "argocd-cm"
#     namespace = "argocd"
#     labels = {
#       "app.kubernetes.io/name"      = "argocd-cm"
#       "app.kubernetes.io/part-of"   = "argocd"
#       "app.kubernetes.io/component" = "argocd"
#     }
#   }
#
#   data = {
#     "accounts.admin" = "apiKey"
#   }
#
#   depends_on = [helm_release.argocd]
# }
