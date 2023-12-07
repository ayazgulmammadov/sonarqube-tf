#!/bin/bash

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install Terraform
install_terraform() {
  echo "Installing Terraform..."
  wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update
  sudo apt install terraform -y
}

# Function to install Minikube
install_minikube() {
  echo "Installing Minikube..."
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube
}

# Function to install Docker
install_docker() {
  echo "Installing Docker..."
  sudo apt install ca-certificates curl gnupg wget apt-transport-https -y
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |
    sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
  sudo apt update

  sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

  sudo usermod -aG docker $USER

}

# Function to install Helm
install_helm() {
  echo "Installing Helm..."
  curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg >/dev/null
  sudo apt-get install apt-transport-https -y
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
  sudo apt-get update
  sudo apt-get install helm -y
}

# Function to install kubectl
install_kubectl() {
  echo "Installing kubectl..."
  curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x kubectl
  sudo mv kubectl /usr/local/bin/
}

# Check and install Terraform
if ! command_exists "terraform"; then
  install_terraform
fi

# Check and install Minikube
if ! command_exists "minikube"; then
  install_minikube
fi

# Check and install Helm
if ! command_exists "helm"; then
  install_helm
fi

# Check and install kubectl
if ! command_exists "kubectl"; then
  install_kubectl
fi

# Check and install Docker
if ! command_exists "docker"; then
  install_docker
fi

echo "Validation completed successfully. Please reboot your OS."
newgrp docker