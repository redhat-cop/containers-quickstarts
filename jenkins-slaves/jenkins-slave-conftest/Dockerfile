FROM quay.io/redhat-cop/jenkins-agent-python:v1.0
# ^ needed to install the python yq library 🐍

ENV BATS_VERSION=1.2.0 \
    YQ_VERSION=3.3.2 \
    CONFTEST_VERSION=0.18.2

USER root

RUN curl --fail -skL https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz -o /tmp/conftest.tar.gz && \ 
    tar -C /tmp -xzf /tmp/conftest.tar.gz && \
    mv /tmp/conftest /usr/local/bin && \
    curl --fail -sL  https://github.com/bats-core/bats-core/archive/v${BATS_VERSION}.tar.gz -o  /tmp/bats.tar.gz && \
    tar -C /tmp -xzf /tmp/bats.tar.gz && \
    ./tmp/bats-core-${BATS_VERSION}/install.sh /usr/local && \
    echo "na na na na na na na na na 🦇👨‍🦰" && \
    rm -rf /tmp/conftest.tar.gz /tmp/bats* && \
    chmod -R 775 /usr/local/bin/bats /usr/local/bin/conftest && \
    scl enable rh-python36 'python3 -m pip install yq'

USER 1001
