# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.8-1787634763@sha256:b8c53f907b7ea8934d6bb23b319ca7b5ab567e61a0806ffc80170631cabc7563 AS builder

# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=v2.5.0
RUN curl -L "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-amd64" -o /usr/local/bin/cosign && \
    chmod +x /usr/local/bin/cosign && \
    cosign version

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18

LABEL name="redhat-cop/jenkins-agent-cosign" \
      io.k8s.display-name="Jenkins Agent Cosign" \
      io.k8s.description="The jenkins agent cosign." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-cosign"

COPY --from=builder /usr/local/bin/cosign /usr/local/bin/cosign

RUN cosign version