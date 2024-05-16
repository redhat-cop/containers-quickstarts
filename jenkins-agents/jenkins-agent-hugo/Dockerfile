# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.3-1610@sha256:66233eebd72bb5baa25190d4f55e1dc3fff3a9b77186c1f91a0abdb274452072 AS builder

SHELL ["/bin/bash", "-c"]

USER root

# renovate: datasource=github-releases depName=gohugoio/hugo
ARG HUGO_VERSION=v0.126.1
RUN curl -L "https://github.com/gohugoio/hugo/releases/download/${HUGO_VERSION}/hugo_extended_${HUGO_VERSION//v}_Linux-64bit.tar.gz" -o /tmp/hugo.tar.gz && \
    tar -xzf /tmp/hugo.tar.gz && \
    mv hugo /usr/local/bin/hugo && \
    hugo version

USER 1001

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.14

LABEL name="redhat-cop/jenkins-agent-hugo" \
      io.k8s.display-name="Jenkins Agent hugo" \
      io.k8s.description="The jenkins agent hugo." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-hugo"

COPY --from=builder /usr/local/bin/hugo /usr/local/bin/hugo
RUN hugo version