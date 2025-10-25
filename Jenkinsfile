pipeline {
    agent any

    environment {
        IMAGE_NAME = "android-builder"
        CONTAINER_NAME = "android-build-container"
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
                echo "🐳 Membangun Docker image Android..."
                bat "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Run Build in Docker') {
            steps {
                echo "🏗️ Menjalankan build di dalam container..."
                bat """
                    docker run --rm ^
                    -v "%CD%":/workspace ^
                    -w /workspace ^
                    ${IMAGE_NAME} bash -c "chmod +x gradlew && ./gradlew clean assembleDebug --no-daemon --stacktrace || true"
                """
            }
        }

        stage('List Artifacts') {
            steps {
                echo "📂 Menampilkan hasil build..."
                bat 'dir app\\build\\outputs\\apk\\debug || echo "❌ File APK tidak ditemukan!"'
            }
        }

        stage('Archive APK') {
            steps {
                echo "📦 Mengarsipkan hasil build APK..."
                archiveArtifacts artifacts: 'app/build/outputs/apk/debug/*.apk', fingerprint: true, allowEmptyArchive: false
            }
        }
    }

    post {
        success {
            echo '✅ Build Sukses! File APK berhasil diarsipkan oleh Jenkins.'
        }
        failure {
            echo '❌ Build Gagal! Periksa log error dari tahap Run Build in Docker.'
        }
    }
}
