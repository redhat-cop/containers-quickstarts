# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.4-1123.1719560047@sha256:081c96d1b1c7cd1855722d01f1ca53360510443737b1eb33284c6c4c330e537c AS builder

SHELL ["/bin/bash", "-c"]

USER root

# renovate: datasource=github-releases depName=gohugoio/hugo
ARG HUGO_VERSION=v0.134.2
RUN curl -L "https://github.com/gohugoio/hugo/releases/download/${HUGO_VERSION}/hugo_extended_${HUGO_VERSION//v}_Linux-64bit.tar.gz" -o /tmp/hugo.tar.gz && \
    tar -xzf /tmp/hugo.tar.gz && \
    mv hugo /usr/local/bin/hugo && \
    hugo version

USER 1001

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.16@sha256:a24511c5d9a071bfbf7d9b2972553a8aac5e44117a959eda30cc2ae068cf31a2

LABEL name="redhat-cop/jenkins-agent-hugo" \
      io.k8s.display-name="Jenkins Agent hugo" \
      io.k8s.description="The jenkins agent hugo." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-hugo"

COPY --from=builder /usr/local/bin/hugo /usr/local/bin/hugo
RUN hugo version