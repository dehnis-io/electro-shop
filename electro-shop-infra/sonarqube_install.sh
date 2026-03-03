#!/bin/bash
set -e

# Update system
sudo apt update 
sudo apt upgrade -y 

# Install required packages
sudo apt install -y wget unzip curl openjdk-17-jdk postgresql postgresql-contrib

# Configure PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

sudo -u postgres psql <<EOF
CREATE USER sonar WITH PASSWORD 'sonar';
CREATE DATABASE sonar WITH OWNER sonar;
GRANT ALL PRIVILEGES ON DATABASE sonar TO sonar;
\c sonar
GRANT ALL ON SCHEMA public TO sonar;
EOF

# Increase system limits for SonarQube
sudo tee -a /etc/security/limits.conf << EOF
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOF

sudo tee -a /etc/sysctl.conf << EOF
vm.max_map_count=262144
fs.file-max=65536
EOF

sudo sysctl -p

# Create SonarQube user
sudo useradd -m -s /bin/bash sonarqube

# Download and install SonarQube
cd /opt
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.5.90363.zip
sudo unzip sonarqube-9.9.5.90363.zip
sudo mv sonarqube-9.9.5.90363 sonarqube
sudo rm sonarqube-9.9.5.90363.zip

# Set permissions
sudo chown -R sonarqube:sonarqube /opt/sonarqube

# Configure SonarQube with minimal memory settings
sudo tee /opt/sonarqube/conf/sonar.properties << EOF
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.jdbc.url=jdbc:postgresql://localhost/sonar

sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaOpts=-Xmx256m -Xms256m -XX:+HeapDumpOnOutOfMemoryError

sonar.ce.javaOpts=-Xmx256m -Xms256m -XX:+HeapDumpOnOutOfMemoryError

sonar.search.javaOpts=-Xmx256m -Xms256m -XX:MaxDirectMemorySize=128m -XX:+HeapDumpOnOutOfMemoryError

sonar.log.level=INFO
sonar.path.logs=/opt/sonarqube/logs
sonar.updatecenter.activate=false
EOF

# Create systemd service
sudo tee /etc/systemd/system/sonarqube.service << EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target postgresql.service

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

# Configure firewall if active
if command -v ufw &> /dev/null; then
    sudo ufw allow 9000/tcp
fi

# Start SonarQube
sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

# Get public IP
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

# Display access information
echo "==========================================" 
echo "Electro-shop-sonar-server Ready!" 
echo "==========================================" 
echo "SonarQube is being installed and configured." 
echo "Access SonarQube at: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):9000" 
echo "Default credentials: admin / admin" 
echo "" 
echo "Please wait 2-3 minutes for SonarQube to fully start." 
echo "==========================================" 

# Create marker file
sudo touch /var/log/electro-shop-sonar-install-complete