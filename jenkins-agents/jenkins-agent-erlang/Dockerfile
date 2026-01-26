# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.7-1769417801@sha256:c8df11b65b18fcf384d5b7fa53e2a92f381a2d9ad78b9de41dc6f2aa161a0e04 AS builder

# renovate: datasource=github-releases depName=erlang/rebar3
ARG REBAR3_VERSION=3.24.0
RUN curl -L "https://github.com/erlang/rebar3/releases/download/${REBAR3_VERSION}/rebar3" -o /usr/local/bin/rebar3 && \
    chmod +x /usr/local/bin/rebar3

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18

SHELL ["/bin/bash", "-c"]

LABEL name="redhat-cop/jenkins-agent-erlang" \
      io.k8s.display-name="Jenkins Agent erlang" \
      io.k8s.description="The jenkins agent erlang." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-erlang"

# renovate: datasource=github-releases depName=rabbitmq/erlang-rpm
ARG ERLANG_VERSION=v27.3.4

USER root

COPY --from=builder /usr/local/bin/rebar3 /usr/local/bin/rebar3
RUN dnf install -y "https://github.com/rabbitmq/erlang-rpm/releases/download/${ERLANG_VERSION}/erlang-${ERLANG_VERSION//v}-1.el8.x86_64.rpm" && \
    dnf clean all

USER 1001

RUN erl -version && \
    rebar3 version