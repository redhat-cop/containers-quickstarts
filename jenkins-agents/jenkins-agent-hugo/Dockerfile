FROM quay.io/openshift/origin-jenkins-agent-base:4.9@sha256:94025d11174dbf836427236733d1b82010a21cf83c5321ec168db761fc2c28e7

ENV HUGO_VERSION=0.83.1

RUN curl -sL https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    | tar zxf - -C /usr/local/bin hugo

USER 1001
