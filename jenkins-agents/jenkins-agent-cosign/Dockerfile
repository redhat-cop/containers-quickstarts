FROM quay.io/openshift/origin-jenkins-agent-base:4.8

USER root

ARG COSIGN_VERSION=1.0.0

# Install cosign
RUN curl -skL -o /usr/local/bin/cosign https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-amd64 && \
    chmod -R 775 /usr/local/bin/cosign

USER 1001