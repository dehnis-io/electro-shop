#!/bin/bash
set -e

# Update system
sudo apt update 
sudo apt upgrade -y 

# Install JDK 17
sudo apt install openjdk-17-jdk -y 

# Install Docker
sudo apt install -y ca-certificates curl

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
sudo systemctl enable docker
sudo systemctl start docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Install additional useful tools
sudo apt install -y git maven curl wget

# Display server information
echo "=========================================="
echo "Electro-shop-agent Docker Server Ready!"
echo "=========================================="
echo "Java version:"
java -version
echo "Docker version:"
docker --version
echo "Docker Compose version:"
docker compose version
echo "=========================================="

# Create a marker file
sudo touch /var/log/electro-shop-agent-install-complete