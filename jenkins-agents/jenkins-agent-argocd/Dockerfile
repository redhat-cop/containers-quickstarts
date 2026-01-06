# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.7-1767674301@sha256:2c9bb68a869abf7d7417f6639509ab5eb8500d8429ea11ab59e677be5545162b AS builder

SHELL ["/bin/bash", "-c"]

# renovate: datasource=github-releases depName=argoproj/argo-cd
ARG ARGOCD_VERSION=v2.14.21
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.50.1

RUN curl -L "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64" -o /usr/local/bin/argocd && \
    chmod +x /usr/local/bin/argocd && \
    argocd version --client

RUN curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18

LABEL name="redhat-cop/jenkins-agent-argocd" \
      io.k8s.display-name="Jenkins Agent ArgoCD" \
      io.k8s.description="The jenkins agent argocd." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-argocd"

COPY --from=builder /usr/local/bin/argocd /usr/local/bin/argocd
COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq

RUN argocd version --client && \
    yq --version