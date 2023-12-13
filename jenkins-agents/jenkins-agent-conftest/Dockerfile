FROM quay.io/redhat-cop/jenkins-agent-python:v1.1@sha256:5a6ed0e5066d0a58c88158cfdcc66a199178d282094510f910e53c6b5ef9cad3
# ^ needed to install the python yq library 🐍

# renovate: datasource=github-releases depName=bats-core/bats-core
ARG BATS_VERSION=v1.10.0
# renovate: datasource=pypi depName=yq
ARG YQ_VERSION=3.2.3
# renovate: datasource=github-releases depName=open-policy-agent/conftest
ARG CONFTEST_VERSION=v0.46.0

USER root

RUN curl --fail -sL https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz | tar zxf - -C /usr/local/bin conftest && \
    curl --fail -sL  https://github.com/bats-core/bats-core/archive/${BATS_VERSION}.tar.gz | tar zxf - -C /tmp && \
    ./tmp/bats-core-${BATS_VERSION//v}/install.sh /usr/local && \
    echo "na na na na na na na na na 🦇👨‍🦰" && \
    rm -rf /tmp/bats* && \
    pip install yq==${YQ_VERSION}

USER 1001
