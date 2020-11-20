FROM jenkins/jnlp-slave

USER root

RUN yum install -y && \
    curl && \
    gradle && \
    maven

# Dependencies to execute Android builds
RUN yum install -y libc6:i386 && \
    libgcc1:i386 && \
    libncurses5:i386 && \
    libstdc++6:i386 && \
    libz1:i386

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# nvm environment variables
ENV NVM_DIR=/usr/local/nvm \
    NODE_VERSION=8.3.0

# install gcloud
RUN wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-230.0.0-linux-x86_64.tar.gz -O g.tar.gz && \
    tar xf g.tar.gz && \
    rm g.tar.gz && \
    mv google-cloud-sdk /opt/google-cloud-sdk && \
    /opt/google-cloud-sdk/install.sh -q && \
    /opt/google-cloud-sdk/bin/gcloud config set component_manager/disable_update_check true
# add gcloud SDK to path
ENV PATH="${PATH}:/opt/google-cloud-sdk/bin/"

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

SHELL ["/bin/bash", "-c"]

# install node and npm
RUN source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules \
    PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

ENV ANDROID_HOME /opt/android-sdk-linux

# Download Android SDK tools into $ANDROID_HOME
RUN cd /opt && wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android-sdk-tools.zip && \
    unzip -q android-sdk-tools.zip && mkdir -p ${ANDROID_HOME} && mv tools/ ${ANDROID_HOME}/tools/ && \
    rm -f android-sdk-tools.zip

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

# Accept licenses before installing components, no need to echo y for each component
# License is valid for all the standard components in versions installed from this file
# Non-standard components: MIPS system images, preview versions, GDK (Google Glass) and Android Google TV require separate licenses, not accepted there
RUN yes | sdkmanager --licenses

# Platform tools
RUN sdkmanager "platform-tools"

# Emulator
# RUN sdkmanager "emulator"
# For now we'll keep using 26.1.2 ; 26.1.3 had some booting issues...
RUN cd /opt && \
    wget -q https://dl.google.com/android/repository/emulator-linux-4077558.zip -O emulator.zip && \
    unzip -q emulator.zip -d ${ANDROID_HOME} && \
    rm emulator.zip

# NDK (side-by-side)
RUN sdkmanager --install "ndk;21.0.6113669" "ndk;21.1.6352462" "ndk;21.3.6528147" "cmake;3.10.2.4988404"

# Please keep all sections in descending order!
# list all platforms, sort them in descending order, take the newest 8 versions and install them
RUN yes | sdkmanager $( sdkmanager  --list 2>/dev/null| grep platforms | awk -F' ' '{print $1}' | sort -nr -k2 -t- | head -8 )
# list all build-tools, sort them in descending order and install them
RUN yes | sdkmanager $( sdkmanager  --list 2>/dev/null| grep build-tools | awk -F' ' '{print $1}' | sort -nr -k2 -t\; | uniq )
RUN yes | sdkmanager "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1" \
    "add-ons;addon-google_apis-google-23" \
    "add-ons;addon-google_apis-google-22" \
    "add-ons;addon-google_apis-google-21"

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]