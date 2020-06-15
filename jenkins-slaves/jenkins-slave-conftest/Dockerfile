FROM quay.io/openshift/origin-jenkins-agent-base:4.4

ENV BATS_VERSION=1.2.0 \
    YQ_VERSION=3.3.2 \
    CONFTEST_VERSION=0.18.2

RUN curl --fail -skL https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz -o /tmp/conftest.tar.gz && \ 
    tar -C /tmp -xzf /tmp/conftest.tar.gz && \
    mv /tmp/conftest /usr/local/bin && \
    curl --fail -sL  https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/local/bin/yq && \
    curl --fail -sL  https://github.com/bats-core/bats-core/archive/v${BATS_VERSION}.tar.gz -o  /tmp/bats.tar.gz && \
    tar -C /tmp -xzf /tmp/bats.tar.gz && \
    ./tmp/bats-core-${BATS_VERSION}/install.sh /usr/local && \
    echo "na na na na na na na na na 🦇👨‍🦰" && \
    rm -rf /tmp/conftest.tar.gz /tmp/bats* && \
    chmod -R 775 /usr/local/bin/yq /usr/local/bin/bats /usr/local/bin/conftest

USER 1001
