#!/bin/bash
set -e

# Update system
sudo apt update 
sudo apt upgrade -y 

# Install required packages
sudo apt install -y wget unzip curl openjdk-17-jdk -y

# Increase system limits for SonarQube
sudo tee -a /etc/security/limits.conf << EOF
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOF

sudo tee -a /etc/sysctl.conf << EOF
vm.max_map_count=262144
fs.file-max=65536
EOF

# Create SonarQube user
sudo useradd -m -s /bin/bash sonarqube
echo "sonarqube:sonarqube" | sudo chpasswd

# Download and install SonarQube
cd /opt
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.5.90363.zip
sudo unzip sonarqube-9.9.5.90363.zip
sudo mv sonarqube-9.9.5.90363 sonarqube
sudo rm sonarqube-9.9.5.90363.zip

# Set permissions
sudo chown -R sonarqube:sonarqube /opt/sonarqube

# Configure SonarQube
sudo tee /opt/sonarqube/conf/sonar.properties << EOF
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.jdbc.url=jdbc:h2:tcp://localhost:9092/sonar
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:MaxDirectMemorySize=256m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=/opt/sonarqube/logs
EOF

# Create systemd service
sudo tee /etc/systemd/system/sonarqube.service << EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Group=sonarqube
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

# Start SonarQube
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

# Display server information
echo "=========================================="
echo "Electro-shop-sonar-server Ready!"
echo "=========================================="
echo "SonarQube is being installed and configured."
echo "Access SonarQube at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9000"
echo "Default credentials: admin / admin"
echo ""
echo "Please wait 2-3 minutes for SonarQube to fully start."
echo "=========================================="

# Create a marker file
sudo touch /var/log/electro-shop-sonar-install-complete