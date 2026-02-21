pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-node-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm test'
            }
        }

        stage('Docker Build') {
            steps {
                sh "docker build -t %IMAGE_NAME%:%IMAGE_TAG% ."
            }
        }

        stage('Docker Images List') {
            steps {
                sh 'docker images'
            }
        }

    }

    post {
        success {
            echo "✅ Build Successful - Docker Image Created"
        }
        failure {
            echo "❌ Build Failed - Check Logs"
        }
    }
}
