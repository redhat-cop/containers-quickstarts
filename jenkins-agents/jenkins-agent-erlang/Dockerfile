# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.5-1739751568@sha256:d342aa80781bf41c4c73485c41d8f1e2dbc40ee491633d9cafe787c361dd44ff AS builder

# renovate: datasource=github-releases depName=erlang/rebar3
ARG REBAR3_VERSION=3.24.0
RUN curl -L "https://github.com/erlang/rebar3/releases/download/${REBAR3_VERSION}/rebar3" -o /usr/local/bin/rebar3 && \
    chmod +x /usr/local/bin/rebar3

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.16

SHELL ["/bin/bash", "-c"]

LABEL name="redhat-cop/jenkins-agent-erlang" \
      io.k8s.display-name="Jenkins Agent erlang" \
      io.k8s.description="The jenkins agent erlang." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-erlang"

# renovate: datasource=github-releases depName=rabbitmq/erlang-rpm
ARG ERLANG_VERSION=v26.2.5

USER root

COPY --from=builder /usr/local/bin/rebar3 /usr/local/bin/rebar3
RUN dnf install -y "https://github.com/rabbitmq/erlang-rpm/releases/download/${ERLANG_VERSION}/erlang-${ERLANG_VERSION//v}-1.el8.x86_64.rpm" && \
    dnf clean all

USER 1001

RUN erl -version && \
    rebar3 version