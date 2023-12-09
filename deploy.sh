#!/bin/bash

# Start Minikube with Docker driver, 2 CPUs, and 6114MB of memory
minikube start --driver=docker --cpus 2 --memory 6114

# Enable Minikube Ingress addon
minikube addons enable ingress

# Prompt the user for the secret value
read -s -p "Enter Postgresql database password: " secret_value
echo

# Set the secret as an environment variable
export TF_VAR_sonarqube_secret_value=$secret_value

export TF_VAR_postgresql_secret_value=$secret_value

# Initialize Terraform in the current directory
terraform init

# Validate Terraform configuration
terraform validate

# Check if validation was successful
if [ $? -eq 0 ]; then
    echo "Terraform validation successful. Proceeding with apply."
    # Apply Terraform configuration with auto-approval
    terraform apply -auto-approve
    # Get Minikube IP
    minikubeip=$(minikube ip)
    echo "$(minikube ip) sonarqube.localhost" | sudo tee -a /etc/hosts

    # Print Sonarqube URL
    echo "Sonarqube URL: http://sonarqube.localhost/"
else
    echo "Terraform validation failed. Please fix the configuration before applying."
fi


