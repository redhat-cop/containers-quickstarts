# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.7-1769417801@sha256:c8df11b65b18fcf384d5b7fa53e2a92f381a2d9ad78b9de41dc6f2aa161a0e04 AS builder

RUN dnf install -y unzip && \
    dnf clean all

# renovate: datasource=github-releases depName=gradle/gradle
ARG GRADLE_VERSION=8.14
RUN curl -L "https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip" -o /tmp/gradle-bin.zip && \
    unzip -q /tmp/gradle-bin.zip -d /opt/gradle-bin && \
    mv /opt/gradle-bin/gradle-${GRADLE_VERSION} /opt/gradle

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18

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
