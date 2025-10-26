FROM openjdk:17-jdk-slim

# Install dependencies
RUN apt-get update && apt-get install -y wget unzip git curl zip && rm -rf /var/lib/apt/lists/*

# Set Android SDK environment
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# Install Android command line tools
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip -d ${ANDROID_HOME}/cmdline-tools && \
    rm cmdline-tools.zip

# Accept licenses
RUN yes | sdkmanager --licenses

# Install essential SDK packages
RUN sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.2"

# Set working directory
WORKDIR /workspace

