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

# Unduh dan pasang Android Command Line Tools
RUN cd ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip && rm tools.zip && \
    mv cmdline-tools latest

# Update dan install komponen SDK yang diperlukan
RUN yes | sdkmanager --sdk_root=${ANDROID_HOME} --licenses || true
RUN sdkmanager --sdk_root=${ANDROID_HOME} --update
RUN sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Atur direktori kerja di dalam container
WORKDIR /app

# Salin seluruh kode proyek ke dalam container
COPY . .

# Pastikan Gradle wrapper dapat dieksekusi
RUN chmod +x gradlew

# Jalankan proses build debug APK
RUN ./gradlew clean assembleDebug --no-daemon

# Tampilkan hasil build
CMD ["bash", "-c", "ls -lah app/build/outputs/apk/debug && echo '✅ Build selesai! File APK tersedia di folder output.'"]
