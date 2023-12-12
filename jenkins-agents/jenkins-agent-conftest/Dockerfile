FROM quay.io/redhat-cop/jenkins-agent-python:v1.1@sha256:5a6ed0e5066d0a58c88158cfdcc66a199178d282094510f910e53c6b5ef9cad3
# ^ needed to install the python yq library 🐍

# renovate: datasource=github-releases depName=bats-core/bats-core
ARG BATS_VERSION=1.2.0
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=2.12.0
# renovate: datasource=github-releases depName=open-policy-agent/conftest
ARG CONFTEST_VERSION=0.23.0

USER root

RUN curl --fail -sL https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz | tar zxf - -C /usr/local/bin conftest && \
    curl --fail -sL  https://github.com/bats-core/bats-core/archive/v${BATS_VERSION}.tar.gz | tar zxf - -C /tmp && \
    ./tmp/bats-core-${BATS_VERSION}/install.sh /usr/local && \
    echo "na na na na na na na na na 🦇👨‍🦰" && \
    rm -rf /tmp/bats* && \
    pip install yq==${YQ_VERSION}

USER 1001
