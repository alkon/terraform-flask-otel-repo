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

provider "argocd" {
  # Used the NodePort address to connect to the ArgoCD server.
  server_addr = "localhost:8082" #"${data.kubernetes_nodes.cluster_node.nodes[0].status.0.addresses.0.address}:${module.argocd.argocd_server_node_port}"

  # The generated authentication token. This is the primary credential.
  auth_token  = var.argocd_auth_token

  # For clusters with self-signed certificates.
  insecure = true
}
