# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.5-1734081738@sha256:aa149a2e32725b0ea9c8ac97d25e65a894b1a4b2f220dd7670d890e60a733a14 AS builder

# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=v2.4.0
RUN curl -L "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-amd64" -o /usr/local/bin/cosign && \
    chmod +x /usr/local/bin/cosign && \
    cosign version

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.16

LABEL name="redhat-cop/jenkins-agent-cosign" \
      io.k8s.display-name="Jenkins Agent Cosign" \
      io.k8s.description="The jenkins agent cosign." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-cosign"

COPY --from=builder /usr/local/bin/cosign /usr/local/bin/cosign

RUN cosign version