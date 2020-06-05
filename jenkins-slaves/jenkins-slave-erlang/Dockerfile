FROM quay.io/openshift/origin-jenkins-agent-base:4.4

ARG ERLANG_VERSION=22.1.4
ARG REBAR3_VERSION=3.12.0

RUN set -xe && \
    curl -LO https://github.com/rabbitmq/erlang-rpm/releases/download/v${ERLANG_VERSION}/erlang-${ERLANG_VERSION}-1.el7.x86_64.rpm && \
    rpm -Uvh ./erlang-${ERLANG_VERSION}-1.el7.x86_64.rpm && \
    rm *.rpm && \
    curl -Lo /usr/local/bin/rebar3 https://github.com/erlang/rebar3/releases/download/${REBAR3_VERSION}/rebar3 && \
    chmod +x /usr/local/bin/rebar3 && \
    yum clean all -y

USER 1001
