variable "kubeconfig_path" {
  description = "The path to the Kubernetes configuration file"
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace for deploying SonarQube"
  type        = string
}

variable "sonarqube_chart_repository" {
  description = "The repository containing the Helm chart for SonarQube"
  type        = string
}

variable "sonarqube_chart_version" {
  description = "The version of the SonarQube Helm chart"
  type        = string
}

variable "sonarqube_chart_name" {
  description = "The name of the SonarQube Helm chart"
  type        = string
}

variable "sonarqube_memory_limit" {
  description = "The memory limit for the SonarQube deployment"
  type        = string
}

variable "sonarqube_secret_name" {
  description = "The secret used to load environment variables from"
  type        = string
}

variable "sonarqube_secret_value" {
  description = "The secret value for the SONARQUBE_JDBC_PASSWORD env variable"
  type        = string
}

variable "sonarqube_configmap_name" {
  description = "The ConfigMap used to load environment variables from"
  type        = string
}

variable "sonarqube_persistence_enabled" {
  description = "Enable persistence for the SonarQube deployment"
  type        = bool
}

variable "postgresql_enabled" {
  description = "Set to false to use an external PostgreSQL server"
  type        = bool
}


variable "sonarqube_db_username" {
  description = "The username for connecting to the database"
  type        = string
}


variable "sonarqube_db_name" {
  description = "The name of the database to connect to"
  type        = string
}