pipeline {
    agent any

    environment {
        ANDROID_HOME = "C:\\Users\\Farrel\\AppData\\Local\\Android\\Sdk"
        JAVA_HOME = "C:\\Program Files\\Android\\Android Studio\\jbr"
        PATH = "${ANDROID_HOME}\\cmdline-tools\\latest\\bin;${ANDROID_HOME}\\platform-tools;${env.PATH}"
    }

    stages {

        stage('Checkout Source') {
            steps {
                echo "🔄 Mengambil source code dari GitHub..."
                git branch: 'main', url: 'https://github.com/Farrell354/komputasi-awan-mobile-app-notes.git'
            }
        }

        stage('Cek Gradle Wrapper') {
            steps {
                echo "🧩 Mengecek file gradlew..."
                bat 'if exist gradlew.bat (echo ✅ gradlew ditemukan) else (echo ❌ gradlew tidak ditemukan!)'
            }
        }

        stage('Build APK Debug') {
            steps {
                echo "🏗️ Membuild file APK Debug..."
                bat '.\\gradlew.bat clean assembleDebug --stacktrace'
            }
        }

        stage('Unit Test (Optional)') {
            steps {
                echo "🧪 Menjalankan unit test..."
                bat '.\\gradlew.bat testDebugUnitTest'
            }
        }

        stage('List APK') {
            steps {
                echo "📂 Menampilkan hasil build..."
                bat 'dir app\\build\\outputs\\apk\\debug'
            }
        }

        stage('Archive APK') {
            steps {
                echo "📦 Mengarsipkan file APK hasil build..."
                archiveArtifacts artifacts: 'app/build/outputs/apk/debug/*.apk', fingerprint: true, allowEmptyArchive: false
            }
        }
    }

    post {
        success {
            echo '✅ Build sukses! File APK telah diarsipkan oleh Jenkins.'
        }
        failure {
            echo '❌ Build gagal! Cek log error di console Jenkins.'
        }
    }
}
