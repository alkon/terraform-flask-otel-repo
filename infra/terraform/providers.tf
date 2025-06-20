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

    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k3d-${var.k3d_cluster_name}"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "k3d-${var.k3d_cluster_name}"
  }
}

provider "kubectl" {
  config_path    = "~/.kube/config"
  config_context = "k3d-${var.k3d_cluster_name}"
}
