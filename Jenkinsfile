pipeline {
    agent any

    environment {
        IMAGE_NAME = "kompu-mobile-notes"
        DOCKERHUB_USER = "farelmario"   // username Docker Hub kamu
        DOCKERHUB_CREDENTIALS = "dockerhub-credentials" // ID credential Jenkins
        PATH = "C:\\Program Files\\Docker\\Docker\\resources\\bin;C:\\Program Files\\Docker;C:\\ProgramData\\DockerDesktop\\version-bin"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "🔄 Cloning repository..."
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build Docker Image (Android Builder)') {
            steps {
                echo "🏗️ Building Docker image..."
                bat "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Build APK Inside Docker') {
            steps {
                echo "📱 Building APK inside container..."
                // Jalankan container sementara untuk build APK
                bat "docker run --rm -v %CD%:/app ${IMAGE_NAME} ./gradlew assembleDebug"
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "📤 Push image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    bat "docker login -u %USER% -p %PASS%"
                    bat "docker tag ${IMAGE_NAME} ${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
                    bat "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:latest"
                }
            }
        }

        stage('Archive APK') {
            steps {
                echo "📦 Archiving APK file..."
                archiveArtifacts artifacts: '**/app/build/outputs/apk/debug/*.apk', fingerprint: true
            }
        }
    }

    post {
        success {
            echo "✅ Build & Push Sukses!"
        }
        failure {
            echo "❌ Build gagal. Periksa log di Jenkins console output."
        }
    }
}
