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


    }

}