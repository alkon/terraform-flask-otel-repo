# modules/thanos/main.tf

terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# Deploy Thanos Receiver
resource "helm_release" "thanos_receiver" {
  name       = "thanos-receiver"
  chart      = "../../chart-backup/thanos/thanos-15.14.1.tgz"
  version    = "15.14.1"

  namespace        = "thanos-ns"
  create_namespace = true

  set {
    name  = "queryFrontend.enabled"
    value = "false"
  }

  set {
    name  = "receive.enabled"
    value = "true"
  }

  set {
    name  = "receive.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "receive.service.ports.remote"
    value = "19291"
  }

  set {
    name  = "receive.service.ports.grpc"
    value = "10901"
  }
}

# Deploy Thanos Receiver
/*
resource "helm_release" "thanos_receiver" {
  name       = "thanos-receiver"
  # repository = "https://charts.bitnami.com/bitnami" # Comment out or remove this line
  chart      = "../../chart-backup/thanos/thanos-15.14.1.tgz" # <-- UPDATED: Reference the local .tgz file from chart-backup
  version    = "15.14.1" # Still specify the version for Terraform's internal tracking

  namespace        = "thanos-ns"
  create_namespace = true

  set {
    name  = "queryFrontend.enabled"
    value = "false"
  }

  set {
    name  = "receive.enabled"
    value = "true"
  }

  set {
    name  = "receive.extraArgs[0]"
    value = "--receive.remote-write.address=0.0.0.0:19291"
  }
}
*/

# Deploy Thanos Query
resource "helm_release" "thanos_query" {
  name       = "thanos-query"
  chart      = "../../chart-backup/thanos/thanos-15.14.1.tgz" # Using 15.14.1
  #chart      = "oci://registry-1.docker.io/bitnamicharts/thanos"
  version    = "15.14.1"

  namespace        = "thanos-ns"
  create_namespace = false # Namespace already created by receiver

  values = [
    templatefile("${path.module}/values/query-values.yaml.tpl", {
      # The receiver's gRPC endpoint for Thanos Query to connect to
      # thanos_receiver_grpc_endpoint = "thanos-receiver.thanos-ns.svc.cluster.local:10901"
      thanos_receiver_grpc_endpoint = "thanos-receiver-receive.thanos-ns.svc.cluster.local:10901"
    })
  ]

  depends_on = [helm_release.thanos_receiver]
}
