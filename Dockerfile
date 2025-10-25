FROM openjdk:17-jdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y wget unzip git curl zip libc6-dev file && \
    rm -rf /var/lib/apt/lists/*

# Set Android SDK environment
ENV ANDROID_HOME=/usr/local/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Install command line tools and SDKs
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip -d ${ANDROID_HOME}/cmdline-tools/latest && \
    rm tools.zip && \
    export PATH=$PATH:${ANDROID_HOME}/cmdline-tools/latest/bin && \
    yes | sdkmanager --licenses && \
    sdkmanager --update && \
    sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Set workdir
WORKDIR /app

# Copy project files
COPY . .
RUN chmod +x gradlew

# Build APK
RUN ./gradlew clean assembleDebug --no-daemon --stacktrace --info || \
    (echo "⚠️ Gagal build APK, periksa error di atas" && exit 1)

# Output build
CMD ["bash", "-c", "ls -lah app/build/outputs/apk/debug && echo '✅ Build selesai, file APK tersedia.'"]
