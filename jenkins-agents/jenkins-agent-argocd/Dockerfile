# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.5-1744101466@sha256:ea57285741f007e83f2ee20423c20b0cbcce0b59cc3da027c671692cc7efe4dd AS builder

SHELL ["/bin/bash", "-c"]

# renovate: datasource=github-releases depName=argoproj/argo-cd
ARG ARGOCD_VERSION=v2.14.11
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.45.1

RUN curl -L "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64" -o /usr/local/bin/argocd && \
    chmod +x /usr/local/bin/argocd && \
    argocd version --client

RUN curl -L "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:44fdf156ad69a0801c151ca9b4f5271aa81e2508a7fd1de14109006bcf33fa6f

LABEL name="redhat-cop/jenkins-agent-argocd" \
      io.k8s.display-name="Jenkins Agent ArgoCD" \
      io.k8s.description="The jenkins agent argocd." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-argocd"

COPY --from=builder /usr/local/bin/argocd /usr/local/bin/argocd
COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq

RUN argocd version --client && \
    yq --version