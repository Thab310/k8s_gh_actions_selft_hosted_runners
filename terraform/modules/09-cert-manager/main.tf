resource "helm_release" "cert_manager" {
  name = "cert-manager"

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.6.0"

  create_namespace = true
  namespace        = "cert-manager"

  set {
    name  = "prometheus.enabled"
    value = false
  }

  set {
    name  = "installCRDS"
    value = true
  }
}