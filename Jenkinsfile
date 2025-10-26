pipeline {
    agent any

    environment {
        ANDROID_HOME = "C:\\Users\\Farrel\\AppData\\Local\\Android\\Sdk"
        JAVA_HOME = "C:\\Program Files\\Android\\Android Studio\\jbr"
        PATH = "${ANDROID_HOME}\\platform-tools;${ANDROID_HOME}\\tools;${JAVA_HOME}\\bin;${env.PATH}"
        
        // Keystore info (ganti sesuai keystore project)
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
                script {
                    // Jika ingin sign release APK otomatis
                    bat """
                    gradlew assembleRelease \
                        -Pandroid.injected.signing.store.file=%KEYSTORE_PATH% \
                        -Pandroid.injected.signing.store.password=%KEYSTORE_PASSWORD% \
                        -Pandroid.injected.signing.key.alias=%KEYSTORE_ALIAS% \
                        -Pandroid.injected.signing.key.password=%KEY_PASSWORD%
                    """
                }
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
