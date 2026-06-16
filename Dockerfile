FROM ubuntu:24.04

ARG JAVA_PACKAGE=openjdk-21-jdk-headless
ARG FLUTTER_VERSION=3.44.2
ARG ANDROID_SDK_TOOLS_VERSION=13114758
ARG ANDROID_COMPILE_SDK=36
ARG ANDROID_BUILD_TOOLS=36.0.0

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk-linux
ENV ANDROID_SDK_ROOT=/opt/android-sdk-linux
ENV FLUTTER_HOME=/opt/flutter
ENV FLUTTER_ROOT=/opt/flutter
ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    ca-certificates \
    jq \
    sudo \
    wget \
    zip \
    unzip \
    git \
    openssh-client \
    curl \
    bc \
    build-essential \
    software-properties-common \
    ruby-full \
    ruby-bundler \
    libstdc++6 \
    libpulse0 \
    libglu1-mesa \
    locales \
    lcov \
    libsqlite3-dev \
    sqlite3 \
    xxd \
    lftp \
    libxtst6 \
    libnss3-dev \
    libnspr4 \
    libxss1 \
    libasound2t64 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libgdk-pixbuf2.0-0 \
    locales \
    ${JAVA_PACKAGE} \
    xz-utils \
 && sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen \
 && update-locale LANG=${LANG} LC_ALL=${LC_ALL} \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN wget -q "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip" -O /tmp/android-sdk-tools.zip \
 && mkdir -p "${ANDROID_HOME}/cmdline-tools" /root/.android \
 && unzip -q /tmp/android-sdk-tools.zip -d "${ANDROID_HOME}/cmdline-tools" \
 && mv "${ANDROID_HOME}/cmdline-tools/cmdline-tools" "${ANDROID_HOME}/cmdline-tools/latest" \
 && rm /tmp/android-sdk-tools.zip \
 && touch /root/.android/repositories.cfg \
 && yes | sdkmanager --licenses \
 && sdkmanager \
    "platform-tools" \
    "platforms;android-${ANDROID_COMPILE_SDK}" \
    "build-tools;${ANDROID_BUILD_TOOLS}"

RUN git clone --depth 1 --branch "${FLUTTER_VERSION}" https://github.com/flutter/flutter.git "${FLUTTER_HOME}" \
 && git config --global --add safe.directory "${FLUTTER_HOME}" \
 && flutter --disable-analytics \
 && yes | flutter doctor --android-licenses \
 && flutter doctor \
 && flutter precache --android \
 && chown -R root:root "${FLUTTER_HOME}"

WORKDIR /workspace
