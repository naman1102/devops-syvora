resource "kubernetes_namespace" "devops-syvora" {
  metadata {
    name = "k8s-ns-by-tf"
  }
}

resource "kubernetes_deployment" "devops-syvora" {
  metadata {
    name = "terraform-devops-syvora"
    labels = {
      test = "DevopsSyvora"
    }
    namespace = kubernetes_namespace.devops-syvora.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "DevopsSyvora"
      }
    }

    template {
      metadata {
        labels = {
          test = "DevopsSyvora"
        }
      }

      spec {
        container {
          image = "devnaman/devops-syvora:latest"
          name  = "devops-syvora"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "devops-syvora" {
  metadata {
    name      = "devops-syvora-service"
    namespace = kubernetes_namespace.devops-syvora.metadata[0].name
    labels = {
      test = "DevopsSyvora"
    }
  }

  spec {
    selector = {
      test = "DevopsSyvora"
    }

    port {
      port        = 3000
      target_port = 3000
      protocol    = "TCP"
    }

    type = "NodePort"

    #node_port = 30000 # Optional: Specify the exact NodePort
    
    external_traffic_policy = "Local" 
  }
}
