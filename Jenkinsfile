pipeline {
    agent any

    environment {
        IMAGE_NAME = "kompu-mobile-notes"
        DOCKERHUB_USER = "farelmario"
        DOCKERHUB_CREDENTIALS = "dockerhub-credentials"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build Docker Image (Android Builder)') {
            steps {
                bat 'docker build -t %IMAGE_NAME% .'
            }
        }

        stage('Build APK Inside Docker') {
            steps {
                bat 'docker run --rm -v %CD%:/app -w /app %IMAGE_NAME% bash -c "chmod +x gradlew && ./gradlew clean assembleDebug --no-daemon --stacktrace"'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    bat """
                        docker login -u %USER% -p %PASS%
                        docker tag %IMAGE_NAME% %DOCKERHUB_USER%/%IMAGE_NAME%:latest
                        docker push %DOCKERHUB_USER%/%IMAGE_NAME%:latest
                    """
                }
            }
        }

        stage('Archive APK') {
            steps {
                bat 'dir app\\build\\outputs\\apk\\debug'
                archiveArtifacts artifacts: 'app/build/outputs/apk/debug/*.apk', fingerprint: true
            }
        }
    }

    post {
        success {
            echo '✅ Build sukses! APK dan image sudah di-push ke Docker Hub.'
        }
        failure {
            echo '❌ Build gagal. Cek log error pada console Jenkins.'
        }
    }
}
