variable "namespace" {
  description = "The Kubernetes namespace for deploying the solution"
  type        = string
}

variable "postgresql_chart_repository" {
  description = "The repository containing the Helm chart for PostgreSQL"
  type        = string
}

variable "postgresql_chart_name" {
  description = "The name of the Helm chart for PostgreSQL"
  type        = string
}

variable "postgresql_username" {
  description = "The username for accessing the PostgreSQL database"
  type        = string
}

variable "postgresql_database" {
  description = "The name of the PostgreSQL database to be created"
  type        = string
}

variable "postgresql_secret_name" {
  description = "The name of the Kubernetes secret storing PostgreSQL passwords"
  type        = string
}

variable "postgresql_secret_value" {
  description = "The value used to generate a secret for PostgreSQL password"
  type        = string
}