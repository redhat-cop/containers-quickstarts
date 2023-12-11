FROM quay.io/openshift/origin-jenkins-agent-base:4.16@sha256:9e63c022e118b87917bf4af8253f706ec5cde1c20be58fb1ad7b42a2a72b2023

ARG VERSION=1.5.1
ARG WEB_VERSION=0.5.12

WORKDIR /arachni

RUN curl -sLo- https://github.com/Arachni/arachni/releases/download/v${VERSION}/arachni-${VERSION}-${WEB_VERSION}-linux-x86_64.tar.gz | tar xvz -C /arachni --strip-components=1 && \
    chown -R root:root /arachni && \
    chmod -R 775 /arachni

COPY reporters ./system/gems/gems/arachni-${VERSION}/components/reporters

USER 1001
