#!/bin/bash

# Start Minikube with Docker driver, 2 CPUs, and 6114MB of memory
minikube start --driver=docker --cpus 2 --memory 6114

# Enable Minikube Ingress addon
minikube addons enable ingress

# Initialize Terraform in the current directory
terraform init

# Validate Terraform configuration
terraform validate

# Apply Terraform configuration with auto-approval
terraform apply -auto-approve

# Get Minikube IP
minikubeip=$(minikube ip)

# Print Sonarqube URL
echo "Sonarqube URL: http://$minikubeip/"