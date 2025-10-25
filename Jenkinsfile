pipeline {
    agent any

    environment {
        IMAGE_NAME = "android-builder"
        CONTAINER_NAME = "android_build_container"
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "🧱 Membangun Docker image Android build environment..."
                    bat "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Run Build in Docker') {
            steps {
                script {
                    echo "🚀 Menjalankan build APK di dalam container..."
                    bat """
                        docker run --rm ^
                        -v %cd%:/app ^
                        -w /app ^
                        ${IMAGE_NAME} ./gradlew clean assembleDebug --no-daemon
                    """
                }
            }
        }

        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: 'app/build/outputs/apk/debug/*.apk', fingerprint: true
            }
        }
    }

    post {
        success {
            echo '✅ Build sukses! APK sudah diarsipkan oleh Jenkins.'
        }
        failure {
            echo '❌ Build gagal! Cek log error di konsol Jenkins.'
        }
    }
}


