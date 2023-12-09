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

resource "null_resource" "deploy_sonarqube_configmap" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl create configmap ${var.sonarqube_configmap_name} \
        --from-literal SONARQUBE_JDBC_USERNAME=${var.sonarqube_db_username} \
        --from-literal SONARQUBE_DB_NAME=${var.sonarqube_db_name} \
        --from-literal SONARQUBE_DB_HOST=postgresql.${var.namespace}.svc.cluster.local:5432/${var.sonarqube_db_name} \
        --from-literal SONARQUBE_JDBC_URL=jdbc:postgresql://postgresql.${var.namespace}.svc.cluster.local:5432/${var.sonarqube_db_name} \
        -n ${var.namespace}
      EOT
  }
}

resource "null_resource" "deploy_sonarqube_secret" {
  provisioner "local-exec" {
    command = "kubectl create secret generic ${var.sonarqube_secret_name} --from-literal=SONARQUBE_JDBC_PASSWORD=${var.sonarqube_secret_value} -n ${var.namespace}"
  }
}

resource "null_resource" "deploy_sonarqube_ingress" {
  provisioner "local-exec" {
    command = "kubectl apply -f ./sonarqube-ingress.yaml -n ${var.namespace}"
  }
  depends_on = [helm_release.sonarqube]
}

resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  repository = var.sonarqube_chart_repository
  chart      = var.sonarqube_chart_name
  version    = var.sonarqube_chart_version
  namespace  = var.namespace
  depends_on = [null_resource.deploy_sonarqube_configmap, null_resource.deploy_sonarqube_secret]


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
    value = var.postgresql_enabled ? "true" : "false"
  }

  set {
    name  = "extraConfig.configmaps[0]"
    value = var.sonarqube_configmap_name
  }

  set {
    name  = "extraConfig.secrets[0]"
    value = var.sonarqube_secret_name
  }
}