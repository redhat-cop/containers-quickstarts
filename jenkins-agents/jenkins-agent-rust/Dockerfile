FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.16@sha256:431ef25a564d147d6355c72c69c6e185af68178bb69a3d2f763de184150282f5

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