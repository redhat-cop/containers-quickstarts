# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.3-1476@sha256:fc300be6adbdf2ca812ad01efd0dee2a3e3f5d33958ad6cd99159e25e9ee1398 AS builder

SHELL ["/bin/bash", "-c"]

# renovate: datasource=github-releases depName=Arachni/arachni
ARG ARACHNI_VERSION=v1.5.1
ARG WEB_VERSION=0.5.12

RUN curl -L "https://github.com/Arachni/arachni/releases/download/${ARACHNI_VERSION}/arachni-${ARACHNI_VERSION//v}-${WEB_VERSION}-linux-x86_64.tar.gz" -o /tmp/arachni.tar.gz && \
    tar --no-same-owner -xzf /tmp/arachni.tar.gz && \
    mv "/arachni-${ARACHNI_VERSION//v}-${WEB_VERSION}" /arachni && \
    chown -R root:root /arachni && \
    chmod -R 775 /arachni

# Runnable
FROM ghcr.io/garethahealy/containers-quickstarts/jenkins-agent:v4.14

LABEL name="redhat-cop/jenkins-agent-arachni" \
      io.k8s.display-name="Jenkins Agent Arachni" \
      io.k8s.description="The jenkins agent arachni." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-arachni"

COPY --from=builder /arachni /arachni
COPY reporters /arachni/system/gems/gems/arachni-${ARACHNI_VERSION}/components/reporters

WORKDIR /arachni

USER 1001

RUN /arachni/bin/arachni --version