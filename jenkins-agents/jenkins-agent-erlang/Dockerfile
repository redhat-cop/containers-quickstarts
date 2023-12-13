FROM quay.io/openshift/origin-jenkins-agent-base:4.14

# renovate: datasource=github-releases depName=rabbitmq/erlang-rpm
ARG ERLANG_VERSION=v26.2
# renovate: datasource=github-releases depName=erlang/rebar3
ARG REBAR3_VERSION=3.22.1

RUN set -xe && \
    dnf install -y https://github.com/rabbitmq/erlang-rpm/releases/download/${ERLANG_VERSION}/erlang-${ERLANG_VERSION//v}-1.el8.x86_64.rpm && \
    curl -Lo /usr/local/bin/rebar3 https://github.com/erlang/rebar3/releases/download/${REBAR3_VERSION}/rebar3 && \
    chmod +x /usr/local/bin/rebar3 && \
    dnf clean all -y

USER 1001
