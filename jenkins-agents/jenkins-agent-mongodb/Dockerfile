FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:a030f57a5805537195c4a5b0916406c03769c99f405736191fa28284a0b43a16

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