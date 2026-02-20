# ---------------------------- 
# Create EC2 Instances 
# ---------------------------- 

# Jenkins Master Server
resource "aws_instance" "jenkins_master" {
  ami                    = var.ami_id
  instance_type          = var.jenkins_instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.infra_allow_port_sg.id]
  user_data              = templatefile("./jenkins_install.sh", {})

  tags = {
    Name = "Electro-shop-master"
    Role = "Jenkins-Master"
    Environment = "Production"
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
    tags = {
      Name = "Electro-shop-master-root"
    }
  }
}

# Docker Agent Server
resource "aws_instance" "docker_agent" {
  ami                    = var.ami_id
  instance_type          = var.docker_instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.infra_allow_port_sg.id]
  user_data              = templatefile("./docker_agent_install.sh", {})

  tags = {
    Name = "Electro-shop-agent"
    Role = "Docker-Agent"
    Environment = "Production"
  }

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
    tags = {
      Name = "Electro-shop-agent-root"
    }
  }
}

# SonarQube Server
resource "aws_instance" "sonarqube_server" {
  ami                    = var.ami_id
  instance_type          = var.sonarqube_instance_type
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.infra_allow_port_sg.id]
  user_data              = templatefile("./sonarqube_install.sh", {})

  tags = {
    Name = "Electro-shop-sonar-server"
    Role = "SonarQube"
    Environment = "Production"
  }

  root_block_device {
    volume_size = var.sonarqube_volume_size
    volume_type = "gp3"
    encrypted   = true
    tags = {
      Name = "Electro-shop-sonar-root"
    }
  }
}


# ---------------------------- 
# Generate Private Key 
# ---------------------------- 

resource "tls_private_key" "ec2_key" { 
  algorithm = "RSA" 
  rsa_bits  = 4096 
} 


# ---------------------------- 
# Create AWS Key Pair 
# ---------------------------- 

resource "aws_key_pair" "generated_key" { 
  key_name   = var.key_name 
  public_key = tls_private_key.ec2_key.public_key_openssh 
} 
 

# ---------------------------- 
# Save Private Key Locally 
# ---------------------------- 

resource "local_file" "private_key" { 
  content         = tls_private_key.ec2_key.private_key_pem 
  filename        = "${path.module}/${var.key_name}.pem" 
  file_permission = "0400" 
} 

 
# ---------------------------- 
# Security Group (Allow Common Ports)
# ---------------------------- 

resource "aws_security_group" "infra_allow_port_sg" {
  name        = "Electro-Shop-Multi-Server-SG"
  description = "Allow inbound traffic for Jenkins, Docker, and SonarQube"

  dynamic "ingress" {
    for_each = [22, 80, 443, 8080, 9000, 2375, 2376, 5432]
    content {
      description      = "inbound rules"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Electro-Shop-Multi-Server-SG"
    Environment = "Production"
  }
}