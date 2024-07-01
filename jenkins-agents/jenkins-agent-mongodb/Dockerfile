FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.14@sha256:8509a820c0b059505d1642802edf19afacc1485d29cc18eb6b8c94ea7fa0b084

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