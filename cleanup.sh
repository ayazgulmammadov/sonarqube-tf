#!/bin/bash

# Remove SonarQube and PostgreSQL deployments
terraform destroy -auto-approve

# Remove Terraform state files
rm -rf .terraform

# Optionally, clean up other resources like Minikube
# Uncomment the following lines if you want to clean up Minikube as well

# minikube stop
# minikube delete

echo "Cleanup completed successfully."