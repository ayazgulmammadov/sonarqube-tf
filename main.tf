terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path # Adjust the path based on your kubeconfig location
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path # Path to your Kubernetes config file
  }
}

resource "kubernetes_namespace" "sonarqubens" {
  metadata {
    name = var.sonarqube_namespace # Set the desired namespace name
  }
}

resource "null_resource" "deploy_sonarqube_configmap" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f ./kubernetes/sonarqube-configmap.yaml \
        --set data.SONARQUBE_JDBC_USERNAME=${var.postgresql_username} \
        --set data.SONARQUBE_DB_NAME=${var.postgresql_database} \
        --set data.SONARQUBE_JDBC_URL=jdbc:postgresql://postgresql.${var.sonarqube_namespace}.svc.cluster.local:5432/${var.postgresql_database} \
        -n ${var.sonarqube_namespace}" \
      EOT
  }
  depends_on = [kubernetes_namespace.sonarqubens]
}

resource "null_resource" "deploy_sonarqube_secret" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./kubernetes/sonarqube-secret.yaml -n ${var.sonarqube_namespace}"
  }
  depends_on = [kubernetes_namespace.sonarqubens]
}

resource "null_resource" "deploy_postgresql_secret" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./kubernetes/postgresql-secret.yaml -n ${var.sonarqube_namespace}"
  }
  depends_on = [kubernetes_namespace.sonarqubens]
}

resource "null_resource" "deploy_sonarqube_ingress" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./kubernetes/sonarqube-ingress.yaml -n ${var.sonarqube_namespace}"
  }
  depends_on = [helm_release.sonarqube]
}

resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  repository = var.sonarqube_chart_repository
  chart      = var.sonarqube_chart_name
  version    = var.sonarqube_chart_version
  namespace  = var.sonarqube_namespace
  depends_on = [helm_release.postgresql, null_resource.deploy_sonarqube_configmap, null_resource.deploy_sonarqube_secret]


  set {
    name  = "resources.limits.memory"
    value = var.sonarqube_memory_limit
  }

  set {
    name  = "persistence.enabled"
    value = var.sonarqube_persistence_enabled ? "true" : "false"
  }

  set {
    name  = "postgresql.enabled"
    value = "false"
  }

  set {
    name  = "extraConfig.configmaps[0]"
    value = "external-sonarqube-opts"
  }

  set {
    name  = "extraConfig.secrets[0]"
    value = "sonarqube-secret"
  }
}

resource "helm_release" "postgresql" {
  name       = "postgresql"
  repository = var.postgresql_chart_repository
  chart      = var.postgresql_chart_name
  version    = var.postgresql_chart_version
  namespace  = var.sonarqube_namespace
  depends_on = [kubernetes_namespace.sonarqubens, null_resource.deploy_postgresql_secret]

  set {
    name  = "auth.username"
    value = var.postgresql_username
  }

  set {
    name  = "auth.existingSecret"
    value = "postgresql-secret"
  }

  set {
    name  = "auth.database"
    value = var.postgresql_database
  }
}
