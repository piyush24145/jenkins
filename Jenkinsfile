// Jenkinsfile (Works on BOTH Linux & Windows agents)
// ✅ Uses sh on Linux + bat on Windows automatically
// ✅ Builds Docker image + Tags + (Optional) Push to Docker Hub
// ✅ No hardcoded secrets (uses Jenkins Credentials)

pipeline {
  agent any

  options {
    timestamps()
    ansiColor('xterm')
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  environment {
    // ---- App/Docker settings ----
    IMAGE_NAME      = "my-node-app"
    IMAGE_TAG       = "${BUILD_NUMBER}"          // auto tag per build
    // DockerHub repo format: username/repo
    DOCKERHUB_REPO  = "piyushkumar45/piyush24145my-node-app"

    // ---- Jenkins Credentials ID (create in Jenkins) ----
    // Create a credential: Username with password (DockerHub)
    DOCKERHUB_CRED_ID = "dockerhub-creds"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        script {
          if (isUnix()) {
            sh 'node -v && npm -v'
            sh 'npm install'
          } else {
            bat 'node -v'
            bat 'npm -v'
            bat 'npm install'
          }
        }
      }
    }

    stage('Run Tests') {
      steps {
        script {
          if (isUnix()) {
            sh 'npm test'
          } else {
            bat 'npm test'
          }
        }
      }
    }

    stage('Docker Build') {
      steps {
        script {
          if (isUnix()) {
            sh """
              docker version
              docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
              docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_REPO}:${IMAGE_TAG}
              docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_REPO}:latest
            """
          } else {
            bat """
              docker version
              docker build -t %IMAGE_NAME%:%IMAGE_TAG% .
              docker tag %IMAGE_NAME%:%IMAGE_TAG% %DOCKERHUB_REPO%:%IMAGE_TAG%
              docker tag %IMAGE_NAME%:%IMAGE_TAG% %DOCKERHUB_REPO%:latest
            """
          }
        }
      }
    }

    stage('Docker Images List') {
      steps {
        script {
          if (isUnix()) {
            sh 'docker images'
          } else {
            bat 'docker images'
          }
        }
      }
    }

    stage('DockerHub Login & Push') {
      when {
        expression { return env.DOCKERHUB_REPO?.trim() }
      }
      steps {
        withCredentials([usernamePassword(
          credentialsId: env.DOCKERHUB_CRED_ID,
          usernameVariable: 'DH_USER',
          passwordVariable: 'DH_PASS'
        )]) {
          script {
            if (isUnix()) {
              sh """
                echo "\$DH_PASS" | docker login -u "\$DH_USER" --password-stdin
                docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                docker push ${DOCKERHUB_REPO}:latest
                docker logout
              """
            } else {
              // Windows (bat) doesn't support password-stdin the same way reliably in all setups
              // This approach works in most Jenkins Windows agents:
              bat """
                docker login -u %DH_USER% -p %DH_PASS%
                docker push %DOCKERHUB_REPO%:%IMAGE_TAG%
                docker push %DOCKERHUB_REPO%:latest
                docker logout
              """
            }
          }
        }
      }
    }

    // OPTIONAL: Deploy on server (Linux) via SSH (only if you later add SSH creds)
    // stage('Deploy') {
    //   when { expression { return isUnix() } }
    //   steps {
    //     // Example: use SSH Agent plugin + ssh credentials
    //     // sshagent(credentials: ['server-ssh-key']) {
    //     //   sh """
    //     //     ssh -o StrictHostKeyChecking=no ubuntu@YOUR_SERVER_IP '
    //     //       docker pull ${DOCKERHUB_REPO}:${IMAGE_TAG} &&
    //     //       docker stop myapp || true &&
    //     //       docker rm myapp || true &&
    //     //       docker run -d --restart=unless-stopped --name myapp -p 3000:3000 ${DOCKERHUB_REPO}:${IMAGE_TAG}
    //     //     '
    //     //   """
    //     // }
    //   }
    // }

  }

  post {
    success {
      echo "✅ Build SUCCESS | Image: ${DOCKERHUB_REPO}:${IMAGE_TAG}"
    }
    failure {
      echo "❌ Build FAILED - Check logs"
    }
    always {
      // Clean workspace safely
      cleanWs(deleteDirs: true, disableDeferredWipeout: true)
    }
  }
}