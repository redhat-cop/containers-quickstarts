# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.5-1745854298@sha256:f4ebd46d3ba96feb016d798009e1cc2404c3a4ebdac8b2479a2ac053e59f41b4 AS builder

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.45.2
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
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5-1745855087@sha256:e1c4703364c5cb58f5462575dc90345bcd934ddc45e6c32f9c162f2b5617681c

USER root

RUN microdnf update -y && \
    microdnf install -y --nodocs openssl git findutils && \
    microdnf clean all

USER 1001

COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm