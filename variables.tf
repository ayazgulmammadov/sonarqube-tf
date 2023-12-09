variable "kubeconfig_path" {
  description = "Path to the Kubernetes configuration file"
  type        = string
  default     = "~/.kube/config"
}

variable "solution_namespace" {
  description = "The Kubernetes namespace for deploying the SonarQube solution"
  type        = string
  default     = "sonarqubens"
}

variable "sonarqube_chart_repository" {
  description = "The repository containing the Helm chart for SonarQube"
  type        = string
  default     = "https://oteemo.github.io/charts"
}

variable "sonarqube_chart_version" {
  description = "The version of the SonarQube Helm chart to be used"
  type        = string
  default     = "9.11.0"
}

variable "sonarqube_chart_name" {
  description = "The name of the Helm chart for deploying SonarQube"
  type        = string
  default     = "sonarqube"
}

variable "sonarqube_memory_limit" {
  description = "The memory limit allocated for the SonarQube deployment"
  type        = string
  default     = "4Gi"
}

variable "sonarqube_persistence_enabled" {
  description = "Flag to enable or disable persistence for the SonarQube deployment"
  type        = bool
  default     = true
}

variable "sonarqube_configmap_name" {
  description = "The ConfigMap used to load additional environment variables for SonarQube"
  type        = string
  default     = "external-sonarqube-opts"
}

variable "postgresql_enabled" {
  description = "Set to false to use an external PostgreSQL server; true for internal deployment"
  type        = bool
  default     = false
}

variable "sonarqube_secret_name" {
  description = "The name of the secret used to manage sensitive environment variables for SonarQube"
  type        = string
  default     = "sonarqube-secret"
}

variable "sonarqube_secret_value" {
  description = "The secret value for the SONARQUBE_JDBC_PASSWORD environment variable"
  type        = string
}

variable "postgresql_chart_repository" {
  description = "The repository containing the Helm chart for PostgreSQL"
  type        = string
  default     = "oci://registry-1.docker.io/bitnamicharts"
}

variable "postgresql_chart_name" {
  description = "The name of the Helm chart for deploying PostgreSQL"
  type        = string
  default     = "postgresql"
}

variable "postgresql_username" {
  description = "The username for connecting to the PostgreSQL database"
  type        = string
  default     = "sonarqubeuser"
}

variable "postgresql_database" {
  description = "The name of the PostgreSQL database to be created and used by SonarQube"
  type        = string
  default     = "sonarqubedb"
}

variable "postgresql_secret_name" {
  description = "The name of the secret used to manage sensitive information for connecting to PostgreSQL"
  type        = string
  default     = "postgresql-secret"
}

variable "postgresql_secret_value" {
  description = "The value of the secret used for connecting to PostgreSQL"
  type        = string
}
