FROM quay.io/openshift/origin-jenkins-agent-base:4.16@sha256:9e63c022e118b87917bf4af8253f706ec5cde1c20be58fb1ad7b42a2a72b2023

USER root

COPY mongodb-org-3.6.repo /tmp/

RUN rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/*.repo /etc/yum.repos.d/ && \
    dnf --setopt=tsflags=nodocs install -y mongodb-org-tools mongodb-org-shell  && \
    dnf clean all -y && \
    rm -rf /var/cache/dnf

USER 1001
