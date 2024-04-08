# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.3-1476@sha256:fc300be6adbdf2ca812ad01efd0dee2a3e3f5d33958ad6cd99159e25e9ee1398 AS builder

SHELL ["/bin/bash", "-c"]

# renovate: datasource=github-releases depName=stedolan/jq
ARG JQ_VERSION=1.6
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.40.5
# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=v3.14.3
# renovate: datasource=github-releases depName=open-policy-agent/conftest
ARG CONFTEST_VERSION=v0.51.0
# renovate: datasource=github-releases depName=stackrox/kube-linter
ARG KUBE_LINTER_VERSION=v0.6.8
# renovate: datasource=github-releases depName=helm/chart-testing
ARG CT_VERSION=v3.10.1

RUN curl -L "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" -o /usr/local/bin/jq && \
    chmod +x /usr/local/bin/jq && \
    jq --version

RUN curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

RUN curl -L "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tar.gz && \
    tar -xzf /tmp/helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    helm version

RUN curl -L "https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    conftest --version

RUN curl -L "https://github.com/stackrox/kube-linter/releases/download/${KUBE_LINTER_VERSION}/kube-linter-linux.tar.gz" -o /tmp/kube-linter-linux.tar.gz && \
    tar -xzf /tmp/kube-linter-linux.tar.gz && \
    mv kube-linter /usr/local/bin/kube-linter && \
    kube-linter version

RUN curl -L "https://github.com/helm/chart-testing/releases/download/${CT_VERSION}/chart-testing_${CT_VERSION//v}_linux_amd64.tar.gz" -o /tmp/chart-testing.tar.gz && \
    tar -C /tmp -xzf /tmp/chart-testing.tar.gz && \
    mv /tmp/ct /usr/local/bin/ct && \
    ct version

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent-python:v4.14

LABEL name="redhat-cop/jenkins-agent-helm" \
      io.k8s.display-name="Jenkins Agent helm" \
      io.k8s.description="The jenkins agent helm." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-helm"

COPY --from=builder /usr/local/bin/jq /usr/local/bin/jq
COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/local/bin/conftest /usr/local/bin/conftest
COPY --from=builder /usr/local/bin/kube-linter /usr/local/bin/kube-linter
COPY --from=builder /usr/local/bin/ct /usr/local/bin/ct
COPY --from=builder /tmp/etc ${HOME}/.ct

RUN jq --version && \
    yq --version && \
    helm version && \
    conftest --version && \
    kube-linter version && \
    ct version && \
    ls -l "${HOME}/.ct"