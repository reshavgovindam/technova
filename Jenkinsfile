pipeline {
    agent any

    environment {
        IMAGE_NAME = 'technovaaa'
        CONTAINER_NAME = 'technovaaa-running'
        PORT = '3000'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/reshavgovindam/technova.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        // Security scan stage skipped until you install Trivy

        stage('Deploy') {
            steps {
                script {
                    sh "docker rm -f ${CONTAINER_NAME} || echo 'No container to remove'"
                    sh "docker run -d -p ${PORT}:${PORT} --name ${CONTAINER_NAME} ${IMAGE_NAME}"
                }
            }
        }
    }

    post {
        failure {
            echo "Build failed! Check logs for details."
        }
        success {
            echo "Build and deployment succeeded!"
        }
    }
}
