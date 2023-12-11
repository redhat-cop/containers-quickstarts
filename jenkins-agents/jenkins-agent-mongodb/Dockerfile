FROM quay.io/openshift/origin-jenkins-agent-base:4.9@sha256:94025d11174dbf836427236733d1b82010a21cf83c5321ec168db761fc2c28e7

USER root

COPY mongodb-org-3.6.repo /tmp/

RUN rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/*.repo /etc/yum.repos.d/ && \
    dnf --setopt=tsflags=nodocs install -y mongodb-org-tools mongodb-org-shell  && \
    dnf clean all -y && \
    rm -rf /var/cache/dnf

USER 1001
