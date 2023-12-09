terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.23.0"  # Specify the version you require
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path # Adjust the path based on your kubeconfig location
}

resource "kubernetes_namespace" "sonarqubens" {
  metadata {
    name = var.solution_namespace # Set the desired namespace name
  }
}

module "sonarqube" {
  count                         = 1
  source                        = "./modules/sonarqube"
  kubeconfig_path               = var.kubeconfig_path
  namespace                     = var.solution_namespace
  sonarqube_chart_repository    = var.sonarqube_chart_repository
  sonarqube_chart_version       = var.sonarqube_chart_version
  sonarqube_chart_name          = var.sonarqube_chart_name
  sonarqube_memory_limit        = var.sonarqube_memory_limit
  sonarqube_persistence_enabled = var.sonarqube_persistence_enabled
  sonarqube_secret_name         = var.sonarqube_secret_name
  sonarqube_secret_value        = var.sonarqube_secret_value
  sonarqube_configmap_name      = var.sonarqube_configmap_name
  postgresql_enabled            = var.postgresql_enabled
  sonarqube_db_name             = var.postgresql_database
  sonarqube_db_username         = var.postgresql_username
  depends_on                    = [kubernetes_namespace.sonarqubens, module.postgresql]
}

module "postgresql" {
  count                       = 1
  source                      = "./modules/postgresql"
  postgresql_chart_repository = var.postgresql_chart_repository
  postgresql_chart_name       = var.postgresql_chart_name
  namespace                   = var.solution_namespace
  postgresql_username         = var.postgresql_username
  postgresql_secret_name      = var.postgresql_secret_name
  postgresql_database         = var.postgresql_database
  kubeconfig_path             = var.kubeconfig_path
  postgresql_secret_value     = var.postgresql_secret_value
  depends_on                  = [kubernetes_namespace.sonarqubens]
}
