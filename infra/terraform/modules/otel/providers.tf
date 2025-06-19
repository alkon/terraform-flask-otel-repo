terraform {
  required_providers {
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
