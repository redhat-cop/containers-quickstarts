# Builder
FROM registry.access.redhat.com/ubi8/ubi:8.10-1262@sha256:244e9858f9d8a2792a3dceb850b4fa8fdbd67babebfde42587bfa919d5d1ecef AS builder

SHELL ["/bin/bash", "-c"]

# renovate: datasource=repology depName=homebrew/openshift-cli
ARG OC_VERSION=4.18.10
# renovate: datasource=github-releases depName=stedolan/jq
ARG JQ_VERSION=1.6
# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=v3.17.3
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.45.2

RUN curl -L "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux-amd64-rhel8.tar.gz" -o /tmp/openshift-client-linux.tar.gz && \
    tar --no-same-owner -xzf /tmp/openshift-client-linux.tar.gz && \
    mv oc kubectl /usr/local/bin && \
    oc version --client && \
    kubectl version --client

RUN curl -L "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" -o /usr/local/bin/jq  && \
    chmod +x /usr/local/bin/jq && \
    jq --version

RUN curl -L "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tar.gz && \
    tar -xzf /tmp/helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    helm version

RUN curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

# Runnable
FROM registry.access.redhat.com/ubi8/ubi-minimal:8.10-1255@sha256:b2a1bec3dfbc7a14a1d84d98934dfe8fdde6eb822a211286601cf109cbccb075

SHELL ["/bin/bash", "-c"]

# renovate: datasource=github-releases depName=bats-core/bats-core
ARG BATS_VERSION=v1.11.1

LABEL io.k8s.description="OCP Bats"
LABEL io.k8s.display-name="OCP Bats"

RUN microdnf install -y --nodocs gzip tar ncurses && \
    microdnf clean all

COPY --from=builder /usr/local/bin/oc /usr/local/bin/oc
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=builder /usr/local/bin/jq /usr/local/bin/jq
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq

RUN curl -L "https://github.com/bats-core/bats-core/archive/${BATS_VERSION}.tar.gz" -o /tmp/bats.tar.gz && \
    tar -C /tmp -xzf /tmp/bats.tar.gz && \
    ls -lrt /tmp && \
    "/tmp/bats-core-${BATS_VERSION//v}/install.sh" /tmp/bats && \
    ln -s /tmp/bats/bin/bats /usr/local/bin/bats && \
    bats --version

RUN mkdir -p /code

WORKDIR /code

USER 1001
ENTRYPOINT ["bats"]
