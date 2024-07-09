# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.4-1123.1719560047@sha256:081c96d1b1c7cd1855722d01f1ca53360510443737b1eb33284c6c4c330e537c AS builder

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.44.2
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
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4-1134@sha256:a7d837b00520a32502ada85ae339e33510cdfdbc8d2ddf460cc838e12ec5fa5a

USER root

RUN microdnf update -y && \
    microdnf install -y --nodocs openssl git findutils && \
    microdnf clean all

USER 1001

COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm