pipeline {
    agent any

    environment {
        IMAGE_NAME = "android-builder"
        PATH = "C:\\Program Files\\Docker\\Docker\\resources\\bin;C:\\Program Files\\Docker"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "🔄 Mengambil source code..."
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build Docker Image (Android Builder)') {
            steps {
                echo "🐳 Membangun image Docker untuk Android..."
                bat 'docker build -t %IMAGE_NAME% .'
            }
        }

        stage('Build APK Inside Docker') {
            steps {
                echo "🏗️  Menjalankan build APK di dalam container..."
                bat '''
                docker run --rm ^
                -v "%cd%:/app" ^
                %IMAGE_NAME% sh -c "cd /app && chmod +x gradlew && ./gradlew clean assembleDebug --stacktrace || echo '⚠️ Build gagal di dalam Docker'"
                '''
            }
        }

        stage('Archive APK') {
            steps {
                echo "📦 Mengarsipkan hasil APK..."
                archiveArtifacts artifacts: '**/build/outputs/apk/debug/*.apk', fingerprint: true
            }
        }
    }

    post {
        success {
            echo '✅ Build sukses! File APK berhasil diarsipkan.'
        }
        failure {
            echo '❌ Build gagal! Silakan periksa log di stage Build APK Inside Docker.'
        }
    }
}

