FROM quay.io/openshift/origin-jenkins-agent-base:4.14@sha256:1284ffe5b63ee7da4c4463d5f44b471fd42ce01c06f5c72edc195a30dcc1f7f4

USER root

COPY mongodb-org-3.6.repo /tmp/

RUN rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/*.repo /etc/yum.repos.d/ && \
    dnf --setopt=tsflags=nodocs install -y mongodb-org-tools mongodb-org-shell  && \
    dnf clean all -y && \
    rm -rf /var/cache/dnf

USER 1001
