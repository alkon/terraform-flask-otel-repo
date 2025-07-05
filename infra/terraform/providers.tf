terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    argocd = {
      source  = "argoproj-labs/argocd"
      version = "~> 7.0"
    }

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
  }
}

# The Kubernetes provider configuration
provider "kubernetes" {
  config_path    = data.external.k3d_cluster_bootstrap.result.kubeconfig_path
  config_context = "k3d-${data.external.k3d_cluster_bootstrap.result.cluster_name}"
}

# The Helm provider configuration
provider "helm" {
  kubernetes {
    config_path    = data.external.k3d_cluster_bootstrap.result.kubeconfig_path
    config_context = "k3d-${data.external.k3d_cluster_bootstrap.result.cluster_name}"
  }
}

# The Kubectl provider configuration
provider "kubectl" {
  config_path    = data.external.k3d_cluster_bootstrap.result.kubeconfig_path
  config_context = "k3d-${data.external.k3d_cluster_bootstrap.result.cluster_name}"
}

# provider "argocd" {
#   alias   = "main"
#   server_addr = var.argocd_server
#   auth_token  = var.argocd_auth_token
#   insecure    = var.argocd_insecure
# }
provider "argocd" {
  alias       = "main"
  server_addr = "localhost:30080"
  auth_token  = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhcmdvY2QiLCJzdWIiOiJhZG1pbjphcGlLZXkiLCJuYmYiOjE3NTE1NTkxOTYsImlhdCI6MTc1MTU1OTE5NiwianRpIjoiYzg0MDgzNDMtMDY1My00NTVmLTlhNmItZmZjYjU1ZWMxNzc4In0.uYBdMWZbOKVWaghjqXXp4rCTehlQLGZcEV-2NEyr2Sc"
  insecure    = true
  plain_text  = true # no need in variable for this
}