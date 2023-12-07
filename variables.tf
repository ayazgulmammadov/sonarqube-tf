variable "kubeconfig_path" {
  description = "Path to the Kubernetes configuration file"
  type        = string
  default     = "~/.kube/config"
}

variable "sonarqube_namespace" {
  description = "Namespace for SonarQube deployment"
  type        = string
  default     = "sonarqubens"
}

variable "sonarqube_chart_repository" {
  description = "Repository for SonarQube Helm chart"
  type        = string
  default     = "https://oteemo.github.io/charts"
}

variable "sonarqube_chart_version" {
  description = "Version of the SonarQube Helm chart"
  type        = string
  default     = "9.11.0"
}

variable "sonarqube_chart_name" {
  description = "Name of the sonarqube Helm chart"
  type        = string
  default     = "sonarqube"
}

variable "sonarqube_memory_limit" {
  description = "Memory limit for SonarQube deployment"
  type        = string
  default     = "4Gi"
}

variable "sonarqube_persistence_enabled" {
  description = "Enable persistence for SonarQube deployment"
  type        = bool
  default     = true
}

variable "postgresql_chart_repository" {
  description = "Repository for PostgreSQL Helm chart"
  type        = string
  default     = "oci://registry-1.docker.io/bitnamicharts"
}

variable "postgresql_chart_name" {
  description = "Name of the PostgreSQL Helm chart"
  type        = string
  default     = "postgresql"
}

variable "postgresql_username" {
  description = "Username for PostgreSQL database"
  type        = string
  default     = "sonarqubeuser"
}

variable "postgresql_database" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "sonarqubedb"
}
