FROM quay.io/openshift/origin-jenkins-agent-base:4.7

ENV HUGO_VERSION=0.83.1

RUN curl -skL -o /tmp/hugo.tar.gz https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    tar -C /tmp -xzf /tmp/hugo.tar.gz && \
    mv -v /tmp/hugo /usr/local/bin && \
    chmod -R 775 /usr/local/bin/hugo && \
    rm -rf /tmp/*.tar.gz

USER 1001