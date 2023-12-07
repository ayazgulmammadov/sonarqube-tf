terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"  # Adjust the path based on your kubeconfig location
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"  # Path to your Kubernetes config file
  }
}

resource "kubernetes_namespace" "sonarqubens" {
  metadata {
    name = "sonarqubens"  # Set the desired namespace name
  }
}

resource "null_resource" "deploy_sonarqube_configmap" {
  provisioner "local-exec" {
    command = "kubectl apply -f sonarqube-configmap.yaml -n sonarqubens"
  }
  depends_on   = [kubernetes_namespace.sonarqubens]
}

resource "null_resource" "deploy_sonarqube_secret" {
  provisioner "local-exec" {
    command = "kubectl apply -f sonarqube-secret.yaml -n sonarqubens"
  }
  depends_on   = [kubernetes_namespace.sonarqubens]
}

resource "null_resource" "deploy_postgresql_secret" {
  provisioner "local-exec" {
    command = "kubectl apply -f postgresql-secret.yaml -n sonarqubens"
  }
  depends_on   = [kubernetes_namespace.sonarqubens]
}

resource "null_resource" "deploy_sonarqube_ingress" {
  provisioner "local-exec" {
    command = "kubectl apply -f sonarqube-ingress.yaml -n sonarqubens"
  }
  depends_on   = [kubernetes_namespace.sonarqubens]
}

resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  repository = "https://oteemo.github.io/charts"
  chart      = "sonarqube"
  version    = "9.11.0"
  namespace  = "sonarqubens"
  depends_on   = [helm_release.postgresql, null_resource.deploy_sonarqube_configmap, null_resource.deploy_sonarqube_secret]

  
  set {
    name  = "resources.limits.memory"
    value = "4Gi"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
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
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"
  namespace  = "sonarqubens"
  depends_on   = [kubernetes_namespace.sonarqubens, null_resource.deploy_postgresql_secret]

  set{
    name = "auth.username"
    value = "sonarqubeuser"
  }

  set {
    name = "auth.existingSecret"
    value = "postgresql-secret"
  }

  set{
    name = "auth.database"
    value = "sonarqubedb"
  }
}