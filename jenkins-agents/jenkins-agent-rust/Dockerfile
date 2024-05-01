FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.14@sha256:6601534e6375831e6a090e862ee6e1e84d30da6d5ab2b3785ead48b2275d64d9

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