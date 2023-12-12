FROM registry.access.redhat.com/ubi9/ubi-minimal:9.3-1361.1699548032@sha256:c77792b8084ce5946c68f39024fa460ef7769c0eef3fce995e70299e21a7e166

USER root

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=4.23.1

RUN microdnf install -y --nodocs openssl tar git findutils gzip && \
    microdnf update -y && \
    microdnf clean all

ADD VERSION /tmp/version
# helm
RUN source /tmp/version && \
    curl -sL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | \
    tar zxf - -C /usr/local/bin --strip-components 1 linux-amd64/helm && \
    echo "⚓️⚓️⚓️⚓️⚓️"

# yq
RUN curl -sLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    echo "🦨🦨🦨🦨🦨"

USER 1001
