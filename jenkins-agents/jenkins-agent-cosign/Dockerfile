FROM quay.io/openshift/origin-jenkins-agent-base:4.16@sha256:9e63c022e118b87917bf4af8253f706ec5cde1c20be58fb1ad7b42a2a72b2023

USER root

ARG COSIGN_VERSION=2.0.2

# Install cosign
RUN curl -sL -o /usr/local/bin/cosign https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64 && \
    chmod 755 /usr/local/bin/cosign

USER 1001
