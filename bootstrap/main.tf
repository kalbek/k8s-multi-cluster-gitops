resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  create_namespace = true
  version    = "6.0.0"

  set {
    name  = "server.service.type"
    value = "NodePort"
  }
}

resource "helm_release" "crossplane" {
  name       = "crossplane"
  repository = "https://charts.crossplane.io/stable"
  chart      = "crossplane"
  namespace  = "crossplane-system"
  create_namespace = true
  version    = "1.15.0"

  set {
    name  = "args[0]"
    value = "--enable-external-secret-stores"
  }
}
