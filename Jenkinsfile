pipeline {
    agent any

    environment {
        ANDROID_HOME = "C:\\Users\\Farrel\\AppData\\Local\\Android\\Sdk"
        JAVA_HOME = "C:\\Program Files\\Android\\Android Studio\\jbr"
        PATH = "${ANDROID_HOME}\\tools;${ANDROID_HOME}\\tools\\bin;${ANDROID_HOME}\\platform-tools;${env.PATH}"
    }

    stages {

        stage('Checkout Source') {
            steps {
                echo "🔄 Mengambil source code dari GitHub..."
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Gradle Wrapper Permission') {
            steps {
                echo "🧩 Mengecek akses eksekusi gradlew..."
                bat 'if not exist gradlew.bat (echo ❌ gradlew tidak ditemukan!) else (echo ✅ gradlew ditemukan)'
            }
        }

        stage('Build APK') {
            steps {
                echo "🏗️  Membuild APK Debug..."
                bat '.\\gradlew.bat clean assembleDebug --stacktrace'
            }
        }

        stage('Unit Test (Optional)') {
            steps {
                echo "🧪 Menjalankan unit test..."
                bat '.\\gradlew.bat testDebugUnitTest'
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
            echo '✅ Build Sukses! File APK sudah diarsipkan oleh Jenkins.'
        }
        failure {
            echo '❌ Build Gagal! Periksa log error pada Console Output Jenkins.'
        }
    }
}
