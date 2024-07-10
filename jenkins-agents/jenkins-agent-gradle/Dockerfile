# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.4-1123.1719560047@sha256:081c96d1b1c7cd1855722d01f1ca53360510443737b1eb33284c6c4c330e537c AS builder

RUN dnf install -y unzip && \
    dnf clean all

# renovate: datasource=github-releases depName=gradle/gradle
ARG GRADLE_VERSION=8.8
RUN curl -L "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/gradle-bin.zip && \
    unzip -q /tmp/gradle-bin.zip -d /opt/gradle-bin && \
    mv /opt/gradle-bin/gradle-${GRADLE_VERSION} /opt/gradle

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.16

LABEL name="redhat-cop/jenkins-agent-gradle" \
      io.k8s.display-name="Jenkins Agent gradle" \
      io.k8s.description="The jenkins agent gradle." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-gradle"

USER root

COPY --from=builder /opt/gradle /opt/gradle
RUN chown -R 1001:0 /opt/gradle && \
    chmod -R g+rw /opt/gradle

ENV GRADLE_HOME=/opt/gradle
ENV PATH="${PATH}:${GRADLE_HOME}/bin"

USER 1001

RUN gradle --version -g ~/.gradle
