FROM quay.io/openshift/origin-jenkins-agent-base:4.14@sha256:1284ffe5b63ee7da4c4463d5f44b471fd42ce01c06f5c72edc195a30dcc1f7f4

LABEL com.redhat.component="jenkins-agent-rust-ubi7-docker" \
      name="openshift/origin-jenkins-agent-rust-ubi7" \
      version="4.14" \
      architecture="x86_64" \
      release="1" \
      io.k8s.display_name="Jenkins Agent Rust" \
      io.k8s.description="The jenkins agent Rust image has the Rust toolchain on top of the jenkins agent base image" \
      io.openshift.tag="openshift,jenkins,agent,rust"

ENV PATH=$PATH:$HOME/.cargo/bin

ADD ubi8.repo /tmp/ubi8.repo

RUN INSTALL_PKGS="gcc" && \
    rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d && \
    dnf install -y $INSTALL_PKGS && \
    rm -rf /var/cache/dnf && \
    curl https://sh.rustup.rs -sSf | sh -s -- -y

USER 1001
