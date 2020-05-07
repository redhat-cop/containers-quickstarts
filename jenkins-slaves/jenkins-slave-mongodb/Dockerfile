FROM quay.io/openshift/origin-jenkins-agent-base:4.3

USER root

COPY ubi.repo mongodb-org-3.6.repo /etc/yum.repos.d/

RUN DISABLE_REPOS=--disablerepo='rhel-*' && \
    yum $DISABLE_REPOS --setopt=tsflags=nodocs install -y mongodb-org-tools mongodb-org-shell  && \
    yum clean all -y && \
    rm -rf /var/cache/yum

USER 1001
