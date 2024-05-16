# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.4-947.1714667021@sha256:ed84f34cd929ea6b0c247b6daef54dd79602804a32480a052951021caf429494 AS builder

# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=v2.2.4
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