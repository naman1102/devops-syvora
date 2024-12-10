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
    namespace = "k8s-ns-by-tf"
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