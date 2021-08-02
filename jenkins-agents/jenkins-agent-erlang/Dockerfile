FROM quay.io/openshift/origin-jenkins-agent-base:4.7

ARG ERLANG_VERSION=22.1.4
ARG REBAR3_VERSION=3.12.0

RUN set -xe && \
    dnf install -y https://github.com/rabbitmq/erlang-rpm/releases/download/v${ERLANG_VERSION}/erlang-${ERLANG_VERSION}-1.el8.x86_64.rpm && \
    curl -Lo /usr/local/bin/rebar3 https://github.com/erlang/rebar3/releases/download/${REBAR3_VERSION}/rebar3 && \
    chmod +x /usr/local/bin/rebar3 && \
    dnf clean all -y

USER 1001
