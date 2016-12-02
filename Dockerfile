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