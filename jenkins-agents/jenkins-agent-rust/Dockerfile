FROM quay.io/openshift/origin-jenkins-agent-base:4.9@sha256:94025d11174dbf836427236733d1b82010a21cf83c5321ec168db761fc2c28e7

LABEL com.redhat.component="jenkins-agent-rust-ubi7-docker" \
      name="openshift/origin-jenkins-agent-rust-ubi7" \
      version="4.8" \
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
