pipeline {
    agent any

    stages {

        stage('Install Dependencies') {
            steps {
                bat 'npm install'
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t my-node-app .'
            }
        }

    }
}
