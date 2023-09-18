FROM registry.access.redhat.com/ubi9/ubi-minimal:9.1

USER root

ARG YQ_VERSION=4.23.1

RUN microdnf install -y --nodocs openssl tar git findutils gzip && \
    microdnf update -y && \
    microdnf clean all

ADD VERSION /tmp/version
# helm
RUN source /tmp/version && \
    curl -sL https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | \
    tar zxf - -C /usr/local/bin --strip-components 1 linux-amd64/helm && \
    echo "⚓️⚓️⚓️⚓️⚓️"

# yq
RUN curl -sLo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    echo "🦨🦨🦨🦨🦨"

USER 1001
