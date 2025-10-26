pipeline {
    agent any

    environment {
        // Android SDK path
        ANDROID_HOME = "C:\\Users\\Farrel\\AppData\\Local\\Android\\Sdk"

        // Java JDK path (bukan JBR/JetBrains Runtime)
        JAVA_HOME = "C:\\Program Files\\Java\\jdk-17.0.8"

        // Update PATH
        PATH = "${ANDROID_HOME}\\tools;${ANDROID_HOME}\\platform-tools;${JAVA_HOME}\\bin;${env.PATH}"

        // Keystore info untuk signing release APK (ganti sesuai keystore)
        KEYSTORE_PATH = "C:\\Users\\Farrel\\keystore\\my-release-key.jks"
        KEYSTORE_ALIAS = "my-key-alias"
        KEYSTORE_PASSWORD = "password123"
        KEY_PASSWORD = "password123"
    }

    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Build Debug APK') {
            steps {
                bat 'gradlew clean assembleDebug'
            }
        }

        stage('Build Release APK') {
            steps {
                bat """
                gradlew assembleRelease ^
                    -Pandroid.injected.signing.store.file=%KEYSTORE_PATH% ^
                    -Pandroid.injected.signing.store.password=%KEYSTORE_PASSWORD% ^
                    -Pandroid.injected.signing.key.alias=%KEYSTORE_ALIAS% ^
                    -Pandroid.injected.signing.key.password=%KEY_PASSWORD%
                """
            }
        }

        stage('Test APK (Optional)') {
            steps {
                bat 'gradlew testDebugUnitTest'
            }
        }

        stage('Archive APK') {
            steps {
                archiveArtifacts artifacts: 'app\\build\\outputs\\apk\\debug\\*.apk', fingerprint: true
                archiveArtifacts artifacts: 'app\\build\\outputs\\apk\\release\\*.apk', fingerprint: true
            }
        }
    }

    post {
        success {
            echo '✅ Build Sukses! Semua APK sudah diarsipkan oleh Jenkins.'
        }
        failure {
            echo '❌ Build Gagal! Cek log error pada konsol Jenkins.'
        }
    }
}
