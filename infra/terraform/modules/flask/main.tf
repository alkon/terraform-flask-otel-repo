variable "image" {}
variable "instrumentation_name" {}

resource "kubernetes_deployment" "flask" {
  metadata {
    name = "flask-app"
    labels = {
      app = "flask"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "flask"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask"
        }

        annotations = {
          "instrumentation.opentelemetry.io/inject-python" = var.instrumentation_name
        }
      }

      spec {
        container {
          name  = "flask"
          image = var.image
          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "flask_service" {
  metadata {
    name = "flask-service"
  }

  spec {
    selector = {
      app = "flask"
    }

    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}
