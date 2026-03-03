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