# Jenkins Master Server Outputs
output "jenkins_master_public_ip" { 
  value = aws_instance.jenkins_master.public_ip 
  description = "Public IP of the Jenkins Master server"
}

output "jenkins_master_ssh_command" { 
  value = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.jenkins_master.public_ip}" 
  description = "SSH command to connect to Jenkins Master"
}

output "jenkins_master_url" {
  value = "http://${aws_instance.jenkins_master.public_ip}:8080"
  description = "URL to access Jenkins Master"
}

# Docker Agent Server Outputs
output "docker_agent_public_ip" { 
  value = aws_instance.docker_agent.public_ip 
  description = "Public IP of the Docker Agent server"
}

output "docker_agent_ssh_command" { 
  value = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.docker_agent.public_ip}" 
  description = "SSH command to connect to Docker Agent"
}

# SonarQube Server Outputs
output "sonarqube_server_public_ip" { 
  value = aws_instance.sonarqube_server.public_ip 
  description = "Public IP of the SonarQube server"
}

output "sonarqube_server_ssh_command" { 
  value = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.sonarqube_server.public_ip}" 
  description = "SSH command to connect to SonarQube server"
}

output "sonarqube_url" {
  value = "http://${aws_instance.sonarqube_server.public_ip}:9000"
  description = "URL to access SonarQube (default credentials: admin/admin)"
}

# Summary Output
output "deployment_summary" {
  value = <<-EOT
    ========================================
    Electro-Shop Infrastructure Deployed!
    ========================================
    
    Jenkins Master: ${aws_instance.jenkins_master.public_ip}
    URL: http://${aws_instance.jenkins_master.public_ip}:8080
    
    Docker Agent: ${aws_instance.docker_agent.public_ip}
    
    SonarQube Server: ${aws_instance.sonarqube_server.public_ip}
    URL: http://${aws_instance.sonarqube_server.public_ip}:9000
    
    SSH Key: ${var.key_name}.pem
    ========================================
  EOT
}