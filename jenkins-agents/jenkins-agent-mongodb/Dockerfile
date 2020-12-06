FROM quay.io/openshift/origin-jenkins-agent-base:4.6

USER root

COPY mongodb-org-3.6.repo /tmp/

RUN rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/*.repo /etc/yum.repos.d/ && \
    dnf --setopt=tsflags=nodocs install -y mongodb-org-tools mongodb-org-shell  && \
    dnf clean all -y && \
    rm -rf /var/cache/dnf

USER 1001
