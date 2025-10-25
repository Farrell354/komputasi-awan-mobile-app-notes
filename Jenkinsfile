pipeline {
    agent any

    environment {
        IMAGE_NAME = "kompu-mobile-notes"
        DOCKERHUB_USER = "farelmario"   // ganti dengan username Docker Hub kamu
        DOCKERHUB_CREDENTIALS = "dockerhub-credentials"
        PATH = "C:\\Program Files\\Docker\\Docker\\resources\\bin;C:\\Program Files\\Docker;C:\\ProgramData\\DockerDesktop\\version-bin"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t %IMAGE_NAME% .'
            }
        }

        stage('Run Docker Container') {
            steps {
                bat 'docker rm -f kompu-mobile || exit 0'
                bat 'docker run -d --name kompu-mobile -p 3000:3000 %IMAGE_NAME%'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    bat 'docker login -u %USER% -p %PASS%'
                    bat 'docker tag %IMAGE_NAME% %DOCKERHUB_USER%/%IMAGE_NAME%:latest'
                    bat 'docker push %DOCKERHUB_USER%/%IMAGE_NAME%:latest'
                }
            }
        }
    }
}
