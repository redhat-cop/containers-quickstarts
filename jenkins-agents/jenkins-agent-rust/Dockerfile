FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:a030f57a5805537195c4a5b0916406c03769c99f405736191fa28284a0b43a16

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