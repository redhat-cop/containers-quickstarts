FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.16@sha256:a24511c5d9a071bfbf7d9b2972553a8aac5e44117a959eda30cc2ae068cf31a2

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