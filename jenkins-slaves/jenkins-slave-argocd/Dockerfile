FROM quay.io/openshift/origin-jenkins-agent-base:4.3

ARG VERSION=1.4.2

RUN curl -sL  https://github.com/argoproj/argo-cd/releases/download/v${VERSION}/argocd-linux-amd64 -o /usr/local/bin/argocd && \
    chmod -R 775 /usr/local/bin/argocd

USER 1001
