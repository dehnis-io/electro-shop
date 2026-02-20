#!/bin/bash
set -e

# Update system
sudo apt update 
sudo apt upgrade -y 

# Install JDK 17
sudo apt install openjdk-17-jre -y 

# Install Jenkins
sudo apt install -y ca-certificates curl

sudo mkdir -p /etc/apt/keyrings

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \ 
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key 

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \ 
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \ 
  /etc/apt/sources.list.d/jenkins.list > /dev/null 

sudo apt update 
sudo apt install -y jenkins 

# Enable and start Jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Wait for Jenkins to start
sleep 30

# Display server information
echo "=========================================="
echo "Electro-shop-master Jenkins Server Ready!"
echo "=========================================="
echo "Jenkins initial password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo ""
echo "Access Jenkins at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080"
echo "=========================================="

# Create a marker file
sudo touch /var/log/electro-shop-master-install-complete