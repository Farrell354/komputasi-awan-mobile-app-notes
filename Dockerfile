# Gunakan image dasar Android SDK
FROM openjdk:17-jdk

# Install dependencies dasar
RUN apt-get update && apt-get install -y \
    wget unzip git curl \
    && rm -rf /var/lib/apt/lists/*

# Pasang Android SDK
ENV ANDROID_HOME /usr/local/android-sdk
RUN mkdir -p ${ANDROID_HOME} && \
    cd ${ANDROID_HOME} && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O tools.zip && \
    unzip tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    rm tools.zip && \
    mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest

# Tambahkan PATH
ENV PATH=$PATH:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools

# Install SDK platform dan build-tools
RUN yes | sdkmanager --licenses
RUN sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Copy source code
WORKDIR /app
COPY . .

# Build APK
RUN chmod +x gradlew
RUN ./gradlew clean assembleDebug

# Lokasi output
CMD ["bash", "-c", "ls -lah app/build/outputs/apk/debug && echo '✅ Build Selesai'"]
