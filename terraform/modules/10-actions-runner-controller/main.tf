resource "helm_release" "actions_runner_controller" {
  name = "actions-runner-controller"

  repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart      = "actions-runner-controller"
  version    = " 0.23.7"

  namespace = "gh-actions"

  //we will use poll method to auto scale our runners so keep in mind that the longer the sync period the greater the lag.
  set {
    name  = "syncPeriod"
    value = "1m"
  }

  # set {
  #   name = "serviceAccount.name"
  #   value = "actions-runner-controller"
  # }  

  # #! we must add a service account annotation to link the AWS IAM and K8S RBAC systems
  # set {
  #   name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  #   value = aws
  # } 
}

