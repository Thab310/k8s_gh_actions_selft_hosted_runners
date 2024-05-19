resource "kubectl_manifest" "runner" {
  yaml_body = var.runner
}

resource "kubectl_manifest" "autoscaler" {
  yaml_body = var.autoscaler
}