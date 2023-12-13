FROM registry.access.redhat.com/ubi9/ubi-minimal:9.3-1475@sha256:a340f4b9fb261a75c84666a3dccb88e193a116da3cebabaf9bcdc33609b61172

USER root

# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.40.5

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
