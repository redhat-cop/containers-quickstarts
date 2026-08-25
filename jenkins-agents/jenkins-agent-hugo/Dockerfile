# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.8-1787634763@sha256:b8c53f907b7ea8934d6bb23b319ca7b5ab567e61a0806ffc80170631cabc7563 AS builder

SHELL ["/bin/bash", "-c"]

USER root

# renovate: datasource=github-releases depName=gohugoio/hugo
ARG HUGO_VERSION=v0.147.2
RUN curl -L "https://github.com/gohugoio/hugo/releases/download/${HUGO_VERSION}/hugo_extended_${HUGO_VERSION//v}_Linux-64bit.tar.gz" -o /tmp/hugo.tar.gz && \
    tar -xzf /tmp/hugo.tar.gz && \
    mv hugo /usr/local/bin/hugo && \
    hugo version

USER 1001

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18

LABEL name="redhat-cop/jenkins-agent-hugo" \
      io.k8s.display-name="Jenkins Agent hugo" \
      io.k8s.description="The jenkins agent hugo." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-hugo"

COPY --from=builder /usr/local/bin/hugo /usr/local/bin/hugo
RUN hugo version