pipeline {
    agent any

    environment {
        IMAGE_NAME = "android-builder"
        PATH = "C:\\Program Files\\Docker\\Docker\\resources\\bin;C:\\Program Files\\Docker"
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
                bat '''
                docker run --rm ^
                -v "%cd%:/app" ^
                %IMAGE_NAME% bash -c "cd /app && chmod +x gradlew && ./gradlew clean assembleDebug --stacktrace"
                '''
            }
        }

        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: '**/app/build/outputs/apk/debug/*.apk', fingerprint: true
            }
        }
    }

    post {
        success {
            echo '✅ Build sukses! File APK telah diarsipkan oleh Jenkins.'
        }
        failure {
            echo '❌ Build gagal! Periksa log error pada Console Output Jenkins.'
        }
    }
}
