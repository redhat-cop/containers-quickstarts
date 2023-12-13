FROM quay.io/openshift/origin-jenkins-agent-base:4.14

# renovate: datasource=github-releases depName=gohugoio/hugo
ENV HUGO_VERSION=v0.121.1

RUN curl -sL https://github.com/gohugoio/hugo/releases/download/${HUGO_VERSION}/hugo_extended_${HUGO_VERSION//v}_Linux-64bit.tar.gz \
    | tar zxf - -C /usr/local/bin hugo

USER 1001
