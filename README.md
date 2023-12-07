# Sonarqube Deployment on Minikube with Terraform

## Overview

This repository provides scripts and configurations to deploy Sonarqube on a Minikube Kubernetes cluster using Helm and Terraform. The deployment includes configuring Helm, setting up Nginx ingress, installing PostgreSQL via Helm, configuring Sonarqube to use the provisioned database, and finally, deploying Sonarqube with persistent disk volume.

## Requirements

- A Linux system (Ubuntu is used in this example)
- Internet connection
- Minikube
- Helm 3
- kubectl
- docker engine
- Terraform

## Project Structure

- Bash scripts for Minikube setup, Helm configuration, Terraform deployment, and tool installation.
  - `deploy.sh`: Deployment script to execute the necessary steps.
  - `install-tools.sh`: Script to install all required DevOps tools if they don't exist.
- Terraform configurations for Minikube environment setup.
  - `main.tf`: Main Terraform configuration file.
- Kubernetes manifest files, located in the kubernetes folder, required for deployment and running Sonarqube and PostgreSQL in Minikube.
  - `postgresql-secret.yaml`: Secret configuration for PostgreSQL.
  - `sonarqube-ingress.yaml`: Ingress configuration for Sonarqube.
  - `sonarqube-secret.yaml`: Secret configuration for Sonarqube.


## Automated DevOps Tools Installation Script

This script automates the installation of essential DevOps tools on a Linux system. It includes the installation of Terraform, Minikube, Docker, Helm, and kubectl.

## Usage

1. **The repository contains a deployment script `install-tools.sh`. Ensure it has execute permissions:**

    ```bash
    chmod +x install-tools.sh
    ```

2. **Run the installation script:**

    ```bash
    ./install-tools.sh.sh
    ```

3. **Follow any on-screen instructions, if prompted.**

4. **After successful execution, reboot your operating system.**

## Tools Installed

- **Terraform:** Infrastructure as Code (IaC) tool for provisioning and managing infrastructure.
- **Minikube:** Kubernetes cluster manager for local development.
- **Docker:** Platform for automating containerized application deployment.
- **Helm:** Kubernetes package manager for deploying and managing applications.
- **kubectl:** Kubernetes command-line tool for interacting with clusters.

## Notes

- The script may prompt for sudo password during execution.
- Ensure that you have the necessary permissions to install software on the system.
- Some tools may require a system reboot for changes to take effect.


## Deployment Script

- The repository contains a deployment script `deploy.sh`. Ensure it has execute permissions:

    ```bash
    chmod +x deploy.sh
    ```

- Run the deployment script:

    ```bash
    ./deploy.sh
    ```

## Clean Up

To delete the deployed resources:

```bash
./cleanup.sh
```


## Author

### Ayaz Gulmammadov - (gulmammadov.ayaz@gmail.com)

Feel free to customize and enhance the script as needed for your specific use case.


