FROM quay.io/openshift/origin-jenkins-agent-base:4.14

# renovate: datasource=github-releases depName=argoproj/argo-cd
ENV ARGOCD_VERSION=v2.2.3
# renovate: datasource=github-releases depName=mikefarah/yq
ENV YQ_VERSION=v4.16.2

RUN curl -sL  https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64 -o /usr/local/bin/argocd && \
    chmod -R 775 /usr/local/bin/argocd && \
    curl -sL  https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod -R 775 /usr/local/bin/yq

USER 1001
