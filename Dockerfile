# Gunakan base image dengan Java 17
FROM openjdk:17-jdk-slim

# Install dependencies dasar
RUN apt-get update && apt-get install -y wget unzip git curl zip && \
    rm -rf /var/lib/apt/lists/*

# Tentukan lokasi Android SDK
ENV ANDROID_HOME=/usr/local/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

# Buat folder SDK
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools

# Unduh dan pasang command line tools Android terbaru
RUN cd ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip && rm tools.zip && \
    mv cmdline-tools latest

# Terima semua lisensi SDK
RUN yes | sdkmanager --licenses || true

# Instal build-tools dan platform Android
RUN sdkmanager --update
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Atur direktori kerja
WORKDIR /app

# Salin seluruh kode proyek
COPY . .

# Pastikan Gradle wrapper bisa dieksekusi
RUN chmod +x gradlew

# Jalankan build debug
RUN ./gradlew clean assembleDebug --no-daemon

# Tampilkan hasil build
CMD ["bash", "-c", "ls -lah app/build/outputs/apk/debug && echo '✅ Build selesai, file APK tersedia.'"]
# Pastikan kita menggunakan Linux gradlew
RUN ls -lah && \
    if [ -f gradlew.bat ]; then echo "❌ gradlew.bat ditemukan, gunakan gradlew (Linux)!"; exit 1; fi

# Build APK
RUN chmod +x ./gradlew || echo "gradlew sudah executable" && \
    ./gradlew clean assembleDebug --no-daemon || (echo "⚠️ Gagal build, cek error di atas" && exit 1)
