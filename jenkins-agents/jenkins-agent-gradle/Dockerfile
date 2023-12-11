FROM quay.io/openshift/origin-jenkins-agent-base:4.16@sha256:9e63c022e118b87917bf4af8253f706ec5cde1c20be58fb1ad7b42a2a72b2023

ENV GRADLE_VERSION=6.3
ENV GRADLE_USER_HOME=/home/jenkins/.gradle

RUN curl -sL -o /tmp/gradle-bin.zip https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip && \
    mkdir -p /opt/gradle && \
    unzip -q /tmp/gradle-bin.zip -d /opt/gradle && \
    ln -sf /opt/gradle/gradle-$GRADLE_VERSION/bin/gradle /usr/local/bin/gradle && \
    rm -f /tmp/gradle-bin.zip && \
    chown -R 1001:0 /opt/gradle && \
    chmod -R g+rw /opt/gradle && \
    mkdir /home/jenkins/.gradle && \
    chmod 775 /home/jenkins/.gradle && \
    alternatives --auto java

USER 1001
