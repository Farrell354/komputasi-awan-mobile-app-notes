pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'android-notes-builder:latest'
        APK_OUTPUT = 'app/build/outputs/apk/debug/app-debug.apk'
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
                echo "🐳 Membangun Docker image untuk Android build..."
                bat 'docker build -t android-notes-builder .'
            }
        }

        stage('Run Build in Docker') {
            steps {
                echo "🏗️ Menjalankan proses build APK di dalam container Docker..."
                // Jalankan container & mount workspace agar hasil APK muncul di host
                bat 'docker run --rm -v "%cd%":/app -w /app android-notes-builder bash -c "./gradlew clean assembleDebug --no-daemon --stacktrace"'
            }
        }

        stage('Archive APK') {
            steps {
                echo "📦 Mengarsipkan file APK hasil build..."
                archiveArtifacts artifacts: '**/build/outputs/apk/debug/*.apk', fingerprint: true
            }
        }
    }

    post {
        success {
            echo '✅ Build Sukses! File APK sudah dibuat dan diarsipkan oleh Jenkins.'
        }
        failure {
            echo '❌ Build Gagal! Periksa log error Docker di Console Output Jenkins.'
        }
    }
}

