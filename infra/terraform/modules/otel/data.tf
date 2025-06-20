data "http" "cert_manager_crds" {
  url = "https://github.com/cert-manager/cert-manager/releases/download/v1.18.1/cert-manager.crds.yaml"
}


# data "helm_release" "existing_cert_manager" {
#   name      = "cert-manager"
#   namespace = "cert-manager"
# }

# data "kubernetes_manifest" "cert_manager_crds" {
#   manifest = {
#     apiVersion = "apiextensions.k8s.io/v1"
#     kind       = "CustomResourceDefinition"
#     metadata = {
#       name = "certificates.cert-manager.io"
#     }
#   }
# }
