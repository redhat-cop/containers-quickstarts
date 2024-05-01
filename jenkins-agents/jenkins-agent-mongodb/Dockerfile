FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.14@sha256:6601534e6375831e6a090e862ee6e1e84d30da6d5ab2b3785ead48b2275d64d9

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