pipeline {
    agent any

    environment {
        JAVA_HOME = "/usr/lib/jvm/java-17-openjdk-amd64"
        PATH = "${env.JAVA_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build APK in Docker') {
            steps {
                script {
                    docker.image('android-builder:latest').inside {
                        bat 'gradlew clean assembleDebug'
                    }
                }
            }
        }

        stage('Test (Optional)') {
            steps {
                script {
                    docker.image('android-builder:latest').inside {
                        bat 'gradlew testDebugUnitTest'
                    }
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
            echo '✅ Build Sukses! APK sudah diarsipkan oleh Jenkins.'
        }
        failure {
            echo '❌ Build Gagal! Cek log error pada konsol Jenkins.'
        }
    }
}

