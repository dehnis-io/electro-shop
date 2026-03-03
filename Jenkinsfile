pipeline {
    agent { label "jenkins-agent" }

    environment { 
         SONAR_HOST_URL = 'sonarqube-server'
         SONAR_AUTH_TOKEN = credentials('jenkins-sonarqube-token') 
    }

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
		        withSonarQubeEnv('sonarqube-server') { 
                    sh ''' 
                    docker run --rm \ 
                        -e SONAR_HOST_URL=$SONAR_HOST_URL \ 
                        -e SONAR_LOGIN=$SONAR_AUTH_TOKEN \ 
                        -v "$PWD":/usr/src \ 
                        sonarsource/sonar-scanner-cli 
                    ''' 
                } 



	           }	
           }
       }



    }

}