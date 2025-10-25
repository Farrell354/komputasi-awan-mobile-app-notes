pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile'
            args '-u root:root'
        }
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build APK') {
            steps {
                sh './gradlew clean assembleDebug'
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
            echo '✅ Build berhasil! File APK sudah tersedia di Jenkins artifacts.'
        }
        failure {
            echo '❌ Build gagal! Periksa error log di konsol Jenkins.'
        }
    }
}
