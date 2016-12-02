FROM ubuntu:16.04

MAINTAINER Matthias Schippling "strombringer60k@gmail.com"
LABEL version="1.0.0"
LABEL description="Android Docker container for CI"

RUN mkdir -p /opt
WORKDIR /opt

# Install OpenJDK 8
RUN apt-get update && apt-get install -y openjdk-8-jdk openjdk-8-jre-headless

# Install dependencies and build essentials
RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get install -y --force-yes ca-certificates nano rsync sudo zip git build-essential wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl psmisc module-init-tools && \
	apt-get clean

# Install Android SDK
RUN wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
	tar --no-same-owner -xzf android-sdk.tgz && \
	rm -f android-sdk.tgz

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install sdk elements (list from "android list sdk --all --extended")
RUN echo y | android update sdk --all --no-ui --filter platform-tools,build-tools-25.0.1,android-24,android-25,addon-google_apis-google-24,addon-google_apis-google-25,extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services,extra-google-market_licensing,extra-google-play_billing,extra-google-market_apk_expansion,extra-google-gcm
# Updating the SDK tools, but this will fail, so I'm manually copying the tools to the right folder
RUN echo y | android update sdk --all --no-ui --filter tools && \
	unzip /opt/android-sdk-linux/temp/tools_r25.2.3-linux.zip && \
	rm -rf /opt/android-sdk-linux/tools && \
	mv /opt/tools /opt/android-sdk-linux/ && \
	rm -rf /opt/android-sdk-linux/temp

RUN which adb
RUN which android
