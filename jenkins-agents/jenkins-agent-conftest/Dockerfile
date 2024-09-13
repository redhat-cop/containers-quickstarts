# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.4-1123.1719560047@sha256:081c96d1b1c7cd1855722d01f1ca53360510443737b1eb33284c6c4c330e537c AS builder

SHELL ["/bin/bash", "-c"]

# renovate: datasource=github-releases depName=open-policy-agent/conftest
ARG CONFTEST_VERSION=v0.55.0
RUN curl -L "https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    conftest --version

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent-python:v4.16@sha256:e758e9ad095c0b89194e00cfceac85042f1a265d54a2f12663b52d318d7ae9cf

LABEL name="redhat-cop/jenkins-agent-conftest" \
      io.k8s.display-name="Jenkins Agent Conftest" \
      io.k8s.description="The jenkins agent conftest." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-conftest"

SHELL ["/bin/bash", "-c"]

# renovate: datasource=github-releases depName=bats-core/bats-core
ARG BATS_VERSION=v1.11.0

USER root

COPY --from=builder /usr/local/bin/conftest /usr/local/bin/conftest

COPY requirements.txt /requirements.txt
RUN pip3.11 install --no-cache-dir -r /requirements.txt && \
    curl -L "https://github.com/bats-core/bats-core/archive/${BATS_VERSION}.tar.gz" -o /tmp/bats.tar.gz && \
    tar -C /tmp -xzf /tmp/bats.tar.gz && \
    "/tmp/bats-core-${BATS_VERSION//v}/install.sh" /usr/local

USER 1001

RUN yq --version && \
    bats --version && \
    conftest --version