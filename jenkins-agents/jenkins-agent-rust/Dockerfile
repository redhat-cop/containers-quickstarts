FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:c2a62da97d90e3a227a3a6408fdbcb6036ef4949d73d0604de1a5eb58532c263

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

LABEL name="redhat-cop/jenkins-agent-rust" \
      io.k8s.display-name="Jenkins Agent rust" \
      io.k8s.description="The jenkins agent rust." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-rust"

ENV PATH="$PATH:$HOME/.cargo/bin"

USER root

RUN dnf install --nodocs -y gcc && \
    dnf clean all && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y

USER 1001

RUN rustc -V