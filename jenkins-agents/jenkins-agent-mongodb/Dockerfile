FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:ab01d7014770f49c91ee8e835d5dfa14c99f79db371ac0e005484e9d5ad5f0ef

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