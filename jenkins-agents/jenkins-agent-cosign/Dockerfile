FROM quay.io/openshift/origin-jenkins-agent-base:4.9

USER root

ARG COSIGN_VERSION=2.0.2

# Install cosign
RUN curl -sL -o /usr/local/bin/cosign https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64 && \
    chmod 755 /usr/local/bin/cosign

USER 1001
