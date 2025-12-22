FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:c2a62da97d90e3a227a3a6408fdbcb6036ef4949d73d0604de1a5eb58532c263

LABEL name="redhat-cop/jenkins-agent-mongodb" \
      io.k8s.display-name="Jenkins Agent mongodb" \
      io.k8s.description="The jenkins agent mongodb." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-mongodb"

USER root

COPY mongodb-org.repo /etc/yum.repos.d/
RUN dnf install --nodocs -y mongodb-org-tools mongodb-org-shell && \
    dnf clean all

USER 1001

RUN mongo --version