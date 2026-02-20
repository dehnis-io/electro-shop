variable "aws_region" {
  description = "The AWS region to deploy in"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (Ubuntu 22.04 LTS)"
  default     = "ami-0b6c6ebed2801a5cb"
}

variable "key_name" {
  description = "The name of the SSH key pair"
  default     = "Electro-Shop-Key"
}

variable "root_volume_size" {
  description = "Size of the root block device in GB for Jenkins and Docker servers"
  default     = 20
}

variable "sonarqube_volume_size" {
  description = "Size of the root block device in GB for SonarQube server"
  default     = 30  # SonarQube needs more space
}

# Instance type configurations
variable "jenkins_instance_type" {
  description = "EC2 instance type for Jenkins Master server"
  default     = "c7i-flex.large"  # 2 vCPU, 4 GB RAM
}

variable "docker_instance_type" {
  description = "EC2 instance type for Docker Agent server"
  default     = "t3.micro"  # 2 vCPU, 4 GB RAM
}

variable "sonarqube_instance_type" {
  description = "EC2 instance type for SonarQube server"
  default     = "c7i-flex.large"   # 2 vCPU, 8 GB RAM - SonarQube needs more memory
}

# Optional: Enable detailed monitoring
variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring for EC2 instances"
  default     = false
}