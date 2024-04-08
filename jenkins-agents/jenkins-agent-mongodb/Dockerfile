FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.14@sha256:17905a009b78e13ea6e454ed045f5b3e4dd38c87903a924f4e7ca2cf5e1d7ffd

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