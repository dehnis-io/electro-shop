pipeline { 
    //agent { label 'jenkins-agent' } 
    agent any 

    environment { 
        SCANNER_HOME = tool name: 'sonar-scanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation' 
        APP_NAME     = "electro-shop" 
        RELEASE      = "1.0.0" 
        DOCKER_USER  = "techadvocate247" 
        DOCKER_PASS  = 'dockerhub' 
        IMAGE_NAME   = "${DOCKER_USER}/${APP_NAME}" 
        IMAGE_TAG    = "${RELEASE}-${BUILD_NUMBER}" 
        JENKINS_API_TOKEN = credentials("JENKINS_API_TOKEN") 
    } 

    stages { 
        stage('Cleanup Workspace') { 
            steps { 
                cleanWs() 
            } 
        } 

        stage('Checkout Code') { 
            steps { 
                git branch: 'main', 
                    credentialsId: 'github', 
                    url: 'https://github.com/dehnis-io/electro-shop.git' 
            } 
        } 

        stage('SonarQube Analysis') { 
            steps { 
                withSonarQubeEnv('sonarqube-server') { 
                    sh ''' 
                        export SONAR_SCANNER_OPTS="-Xmx512m" 
                        ${SCANNER_HOME}/bin/sonar-scanner \ 
                            -Dsonar.projectKey=electro-shop \ 
                            -Dsonar.projectName="Electro Shop Web App" \ 
                            -Dsonar.sources=. \ 
                            -Dsonar.exclusions=**/node_modules/**,**/*.test.js,lib/owlcarousel/** 
                    ''' 
                } 
            } 
        } 

        stage('Quality Gate') { 
            steps { 
                script { 
                    timeout(time: 5, unit: 'MINUTES') { 
                        def qg = waitForQualityGate() 
                        // ✅ Only print the status — pipeline always continues regardless 
                        if (qg.status == 'OK') { 
                            echo "✅ Quality Gate passed: ${qg.status}" 
                        } else { 
                            echo "⚠️ Quality Gate status: ${qg.status} — continuing pipeline" 
                        } 
                    } 
                } 
            } 
        } 

        stage('Build Docker Image') { 
            steps { 
                script { 
                    echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}" 
                    docker.build("${IMAGE_NAME}:${IMAGE_TAG}") 
                } 
            } 
        } 

        stage('Push Docker Image') { 
            steps { 
                script { 
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_PASS) { 
                        def dockerImage = docker.image("${IMAGE_NAME}:${IMAGE_TAG}") 
                        dockerImage.push("${IMAGE_TAG}") 
                        dockerImage.push("latest") 
                    } 
                } 
            } 
        } 

        stage("Trivy Scan") { 
           steps { 
               script { 
            sh ('docker run -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image techadvocate247/electro-shop:latest --no-progress --scanners vuln  --exit-code 0 --severity HIGH,CRITICAL --format table') 
               } 
           } 
       } 

        stage ('Cleanup Artifacts') { 
           steps { 
               script { 
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG}" 
                    sh "docker rmi ${IMAGE_NAME}:latest" 
               } 
           } 
       } 

        stage("Trigger CD Pipeline") { 
            steps { 
                script { 
                    sh "curl -v -k --user admin:${JENKINS_API_TOKEN} -X POST -H 'cache-control: no-cache' -H 'content-type: application/x-www-form-urlencoded' --data 'IMAGE_TAG=${IMAGE_TAG}' 'ec2-184-72-127-10.compute-1.amazonaws.com:8080/job/Electro-shop-CD/buildWithParameters?token=gitops-token'" 
                } 
            } 
       } 

    } 

    post { 
        success { 
            echo "✅ Pipeline completed successfully — ${IMAGE_NAME}:${IMAGE_TAG} pushed" 
        } 
        failure { 
            echo "❌ Pipeline failed" 
        } 
        always { 
            cleanWs() 
        } 
    } 

} 

