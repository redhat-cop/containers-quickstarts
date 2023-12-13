FROM quay.io/openshift/origin-jenkins-agent-base:4.14

USER root

# renovate: datasource=github-releases depName=sigstore/cosign
ARG COSIGN_VERSION=v2.2.2

# Install cosign
RUN curl -L -o /usr/local/bin/cosign https://github.com/sigstore/cosign/releases/download/${COSIGN_VERSION}/cosign-linux-amd64 && \
    chmod 755 /usr/local/bin/cosign

USER 1001
