FROM quay.io/redhat-cop/jenkins-agent-python:v1.0@sha256:6db6f00490699c05fe7412fad2c1d9f85dd30323f620eab2fc2af6ec0ff60d93
# ^ needed to install the python yq library 🐍

ARG BATS_VERSION=1.2.0
ARG YQ_VERSION=2.12.0
ARG CONFTEST_VERSION=0.23.0

USER root

RUN curl --fail -sL https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz | tar zxf - -C /usr/local/bin conftest && \
    curl --fail -sL  https://github.com/bats-core/bats-core/archive/v${BATS_VERSION}.tar.gz | tar zxf - -C /tmp && \
    ./tmp/bats-core-${BATS_VERSION}/install.sh /usr/local && \
    echo "na na na na na na na na na 🦇👨‍🦰" && \
    rm -rf /tmp/bats* && \
    pip install yq==${YQ_VERSION}

USER 1001
