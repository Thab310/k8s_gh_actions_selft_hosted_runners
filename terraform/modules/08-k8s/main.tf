resource "kubernetes_namespace" "gh_actions" {
  metadata {
    name = "gh-actions"
  }
}


resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}


resource "kubernetes_secret" "github_app_secret" {
  metadata {
    name      = "controller-manager"
    namespace = "gh-actions"
  }

  data = {
    github_app_id              = var.github_app_id
    github_app_installation_id = var.github_app_installation_id
    github_app_private_key     = var.github_app_private_key
  }
}
