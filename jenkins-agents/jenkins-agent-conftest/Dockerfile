FROM quay.io/redhat-cop/jenkins-agent-python:v1.2@sha256:fad872a01fb7013d782b1dccb5c46de38c8e853c158bb42b87db7696d6dbb012
# ^ needed to install the python yq library 🐍

# renovate: datasource=github-releases depName=bats-core/bats-core
ARG BATS_VERSION=v1.10.0
# renovate: datasource=pypi depName=yq
ARG YQ_VERSION=3.2.3
# renovate: datasource=github-releases depName=open-policy-agent/conftest
ARG CONFTEST_VERSION=v0.47.0

USER root

RUN curl --fail -sL https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz | tar zxf - -C /usr/local/bin conftest && \
    curl --fail -sL  https://github.com/bats-core/bats-core/archive/${BATS_VERSION}.tar.gz | tar zxf - -C /tmp && \
    ./tmp/bats-core-${BATS_VERSION//v}/install.sh /usr/local && \
    echo "na na na na na na na na na 🦇👨‍🦰" && \
    rm -rf /tmp/bats* && \
    pip install yq==${YQ_VERSION}

USER 1001
