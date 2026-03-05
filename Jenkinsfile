pipeline {
    agent { label "jenkins-agent" }

    environment {
        // Let Jenkins find the scanner installation
        SCANNER_HOME = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
    }

    stages {

        stage ("Cleanup Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Checkout") {
            steps {
                git branch: 'main', 
                    credentialsId: 'github', 
                    url: 'https://github.com/dehnis-io/electro-shop.git'
            }
        }

        stage("SonarQube Analysis") {
            steps {
                // withSonarQubeEnv automatically uses your global SonarQube config
                withSonarQubeEnv('sonarqube-server') {
                    sh '''
                        # Navigate to workspace
                        cd $WORKSPACE
                        
                        # Run sonar scanner - URL and token come from withSonarQubeEnv
                        $SCANNER_HOME/bin/sonar-scanner \
                            -Dsonar.projectKey=electro-shop \
                            -Dsonar.projectName="Electro Shop Web App" \
                            -Dsonar.sources=. \
                            -Dsonar.exclusions=**/node_modules/**,**/*.test.js
                    '''
                }
            }
        }

        stage("Quality Gate") {
            steps {
                script {
                    timeout(time: 2, unit: 'MINUTES') {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Quality gate failed: ${qg.status}"
                        }
                    }
                }
            }
        }
    }
}