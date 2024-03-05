# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.3-1610@sha256:66233eebd72bb5baa25190d4f55e1dc3fff3a9b77186c1f91a0abdb274452072 AS builder

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.40.5
RUN curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

COPY VERSION /tmp/version
RUN source /tmp/version && \
    curl -L "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tar.gz && \
    tar -xzf /tmp/helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    helm version

# Runnable
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.3-1552@sha256:582e18f13291d7c686ec4e6e92d20b24c62ae0fc72767c46f30a69b1a6198055

USER root

RUN microdnf update -y && \
    microdnf install -y --nodocs openssl git findutils && \
    microdnf clean all

USER 1001

COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm