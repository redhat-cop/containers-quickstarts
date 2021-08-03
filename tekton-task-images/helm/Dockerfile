FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3

USER root

ARG YQ_VERSION=4.11.2

RUN microdnf install --assumeyes --nodocs openssl tar findutils gzip && \
    microdnf update && \
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
