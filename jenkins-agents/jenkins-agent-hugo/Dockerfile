FROM quay.io/openshift/origin-jenkins-agent-base:4.16@sha256:9e63c022e118b87917bf4af8253f706ec5cde1c20be58fb1ad7b42a2a72b2023

ENV HUGO_VERSION=0.83.1

RUN curl -sL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    | tar zxf - -C /usr/local/bin hugo

USER 1001
