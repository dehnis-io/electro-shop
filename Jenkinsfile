pipeline {
    agent { label "jenkins-agent" }

    stages {
        stage ("Cleanup Workspace") {
            steps {
            cleanWs()
            }
        }

        stage ("Checkout from SCM") {
            steps {
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/dehnis-io/electro-shop.git'
            }
        }

        stage("SonarQube Analysis"){
            steps {
	           script {
		        withSonarQubeEnv(credentialsId: 'jenkins-sonarqube-token') { 
                        sh "mvn sonar:sonar"
		        }
	           }	
           }
       }



    }

}