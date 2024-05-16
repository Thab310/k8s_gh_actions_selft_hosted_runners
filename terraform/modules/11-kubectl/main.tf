resource "kubectl" "runner" {
  yaml_body = var.runner
}

resource "kubectl" "autoscaler" {
  yaml_body = var.autoscaler
}