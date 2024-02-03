# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.3-1476@sha256:fc300be6adbdf2ca812ad01efd0dee2a3e3f5d33958ad6cd99159e25e9ee1398 AS builder

# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=v2.2.3
RUN curl -L "https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-amd64" -o /usr/local/bin/cosign && \
    chmod +x /usr/local/bin/cosign && \
    cosign version

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.14

LABEL name="redhat-cop/jenkins-agent-cosign" \
      io.k8s.display-name="Jenkins Agent Cosign" \
      io.k8s.description="The jenkins agent cosign." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-cosign"

COPY --from=builder /usr/local/bin/cosign /usr/local/bin/cosign

RUN cosign version