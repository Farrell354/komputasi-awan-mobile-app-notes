pipeline {
    agent any

    environment {
        IMAGE_NAME = "android-builder"
    }

    stages {
        stage('Checkout Source') {
            steps {
                echo "🔄 Mengambil source code dari GitHub..."
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🧱 Membangun Docker image untuk Android build..."
                bat "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Run Build in Docker') {
            steps {
                echo "🚀 Menjalankan build APK di dalam container..."
                bat """
                    docker run --rm ^
                    -v "%CD%":/app ^
                    -w /app ^
                    ${IMAGE_NAME} bash -c "./gradlew clean assembleDebug --no-daemon || true"
                """
            }
        }

        stage('List Artifacts') {
            steps {
                echo "📂 Mengecek file hasil build..."
                bat 'dir app\\build\\outputs\\apk\\debug'
            }
        }

        stage('Archive APK') {
            steps {
                echo "📦 Mengarsipkan file APK hasil build..."
                archiveArtifacts artifacts: 'app/build/outputs/apk/debug/*.apk', fingerprint: true, allowEmptyArchive: false
            }
        }
    }

    post {
        success {
            echo '✅ Build sukses! File APK sudah diarsipkan oleh Jenkins.'
        }
        failure {
            echo '❌ Build gagal! Cek log error pada Console Output Jenkins.'
        }
    }
}
