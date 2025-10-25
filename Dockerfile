FROM openjdk:17-jdk-slim

RUN apt-get update && apt-get install -y wget unzip git curl zip && \
    rm -rf /var/lib/apt/lists/*

ENV ANDROID_HOME=/usr/local/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

RUN mkdir -p ${ANDROID_HOME}/cmdline-tools/latest && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O tools.zip && \
    unzip tools.zip -d ${ANDROID_HOME}/cmdline-tools/latest && \
    rm tools.zip

RUN yes | sdkmanager --licenses
RUN sdkmanager --update
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

WORKDIR /app
COPY . .

RUN chmod +x ./gradlew
RUN ./gradlew clean assembleDebug --no-daemon --stacktrace --info

CMD ["bash", "-c", "ls -lah app/build/outputs/apk/debug && echo '✅ Build selesai, file APK tersedia.'"]
