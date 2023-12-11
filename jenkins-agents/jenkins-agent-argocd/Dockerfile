FROM quay.io/openshift/origin-jenkins-agent-base:4.9@sha256:94025d11174dbf836427236733d1b82010a21cf83c5321ec168db761fc2c28e7

ENV ARGOCD_VERSION=2.2.3 \
    YQ_VERSION=v4.16.2

RUN curl -sL  https://github.com/argoproj/argo-cd/releases/download/v${ARGOCD_VERSION}/argocd-linux-amd64 -o /usr/local/bin/argocd && \
    chmod -R 775 /usr/local/bin/argocd && \
    curl -sL  https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod -R 775 /usr/local/bin/yq

USER 1001
