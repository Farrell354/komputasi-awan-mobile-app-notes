pipeline {
    agent any

    environment {
        // Path ke Android SDK dan Gradle wrapper
        ANDROID_HOME = "C:\\Users\\%USERNAME%\\AppData\\Local\\Android\\Sdk"
        PATH = "${env.ANDROID_HOME}\\tools;${env.ANDROID_HOME}\\platform-tools;%PATH%"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build APK') {
            steps {
                bat '''
                cd %WORKSPACE%
                chmod +x gradlew
                gradlew clean assembleDebug --stacktrace
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

