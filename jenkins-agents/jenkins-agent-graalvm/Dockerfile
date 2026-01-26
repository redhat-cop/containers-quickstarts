# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.7-1769417801@sha256:c8df11b65b18fcf384d5b7fa53e2a92f381a2d9ad78b9de41dc6f2aa161a0e04 AS builder

SHELL ["/bin/bash", "-c"]

# renovate: datasource=github-releases depName=graalvm/mandrel
ARG GRAAL_VERSION=mandrel-21.3.4.0-Final
# renovate: datasource=github-releases depName=stedolan/jq
ARG JQ_VERSION=1.6
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.50.1
# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=v3.17.3

RUN curl -L "https://github.com/graalvm/mandrel/releases/download/${GRAAL_VERSION}/mandrel-java11-linux-amd64-${GRAAL_VERSION//mandrel-}.tar.gz" -o mandrel-java11.tar.gz && \
    tar -xzf mandrel-java11.tar.gz && \
    mv "mandrel-java11-${GRAAL_VERSION//mandrel-}" /opt/mandrel-java11

RUN curl -L "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" -o /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq && \
    jq --version

RUN curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

RUN curl -L "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tar.gz && \
    tar -xzf /tmp/helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    helm version

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent-mvn:v4.18

LABEL name="redhat-cop/jenkins-agent-graalvm" \
      io.k8s.display-name="Jenkins Agent graalvm" \
      io.k8s.description="The jenkins agent graalvm." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-graalvm"

USER root

RUN dnf install --nodocs -y gcc gcc-c++ glibc-static glibc-devel zlib-devel && \
    dnf clean all

COPY --from=builder /usr/local/bin/jq /usr/local/bin/jq
COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /opt/mandrel-java11 /opt/mandrel-java11

USER 1001

ENV GRAALVM_HOME=/opt/mandrel-java11
ENV PATH="${PATH}:${GRAALVM_HOME}/bin"

RUN jq --version && \
    yq --version && \
    helm version && \
    native-image --version
