# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.3-1476@sha256:fc300be6adbdf2ca812ad01efd0dee2a3e3f5d33958ad6cd99159e25e9ee1398 AS builder

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.43.1
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
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.3-1612@sha256:bc552efb4966aaa44b02532be3168ac1ff18e2af299d0fe89502a1d9fabafbc5

USER root

RUN microdnf update -y && \
    microdnf install -y --nodocs openssl git findutils && \
    microdnf clean all

USER 1001

COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm