terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">=2.12.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path # Path to your Kubernetes config file
  }
}

resource "null_resource" "deploy_postgresql_secret" {
  provisioner "local-exec" {
    command = "kubectl create secret generic ${var.postgresql_secret_name} --from-literal=postgres-password='${var.postgresql_secret_value}' --from-literal=password='${var.postgresql_secret_value}' -n ${var.namespace}"
  }
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = var.postgresql_chart_repository
  chart      = var.postgresql_chart_name
  namespace  = var.namespace
  depends_on = [null_resource.deploy_postgresql_secret]

  set {
    name  = "auth.username"
    value = var.postgresql_username
  }

  set {
    name  = "auth.existingSecret"
    value = var.postgresql_secret_name
  }

  set {
    name  = "auth.database"
    value = var.postgresql_database
  }
}