FROM quay.io/openshift/origin-jenkins-agent-base:4.3

ARG VERSION=3.2.0

RUN curl -skL -o /tmp/helm.tar.gz https://get.helm.sh/helm-v${VERSION}-linux-amd64.tar.gz && \ 
    tar -C /tmp -xzf /tmp/helm.tar.gz && \
    mv /tmp/linux-amd64/helm /usr/local/bin && \
    chmod -R 775 /usr/local/bin/helm && \
    rm -rf /tmp/helm.tar.gz && \
    rm -rf /tmp/linux-amd64 

USER 1001
