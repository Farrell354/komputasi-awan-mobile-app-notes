pipeline {
    agent any

    environment {
        ANDROID_HOME = "C:\\Users\\Farrel\\AppData\\Local\\Android\\Sdk"
        JAVA_HOME = "C:\\Program Files\\Android\\Android Studio\\jbr"
        PATH = "${ANDROID_HOME}\\tools;${ANDROID_HOME}\\platform-tools;${env.PATH}"
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build APK') {
            steps {
                bat 'gradlew clean assembleDebug'
            }
        }

        stage('Test (Optional)') {
            steps {
                bat 'gradlew testDebugUnitTest'
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
