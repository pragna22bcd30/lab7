pipeline {
    agent any

    environment {
        IMAGE_NAME = "pragnasri22bcd30/pragnasri-2022bcd0030"
        CONTAINER_NAME = "temp_ml_container"
    }

    stages {

        stage('Pull Image') {
            steps {
                sh 'docker pull $IMAGE_NAME'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker run -d -p 9000:8000 --name $CONTAINER_NAME $IMAGE_NAME'
            }
        }

        stage('Wait for API') {
            steps {
                script {
                    timeout(time: 1, unit: 'MINUTES') {
                        waitUntil {
                            def status = sh(
                                script: "curl -s http://localhost:9000/health || true",
                                returnStatus: true
                            )
                            return (status == 0)
                        }
                    }
                }
            }
        }

        stage('Run Validation Tests') {
            steps {
                sh 'chmod +x validate.sh'
                sh './validate.sh'
            }
        }

        stage('Stop Container') {
            steps {
                sh 'docker stop $CONTAINER_NAME || true'
                sh 'docker rm $CONTAINER_NAME || true'
            }
        }
    }

    post {
        failure {
            echo "Pipeline Failed ❌"
        }
        success {
            echo "Pipeline Succeeded ✅"
        }
        always {
            sh 'docker rm -f $CONTAINER_NAME || true'
        }
    }
}