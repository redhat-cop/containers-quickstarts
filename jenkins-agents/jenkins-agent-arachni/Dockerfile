FROM quay.io/openshift/origin-jenkins-agent-base:4.14

ARG ARACHNI_VERSION=1.5.1
ARG WEB_VERSION=0.5.12

WORKDIR /arachni

RUN curl -sLo- https://github.com/Arachni/arachni/releases/download/v${ARACHNI_VERSION}/arachni-${ARACHNI_VERSION}-${WEB_VERSION}-linux-x86_64.tar.gz | tar xvz -C /arachni --strip-components=1 && \
    chown -R root:root /arachni && \
    chmod -R 775 /arachni

COPY reporters ./system/gems/gems/arachni-${ARACHNI_VERSION}/components/reporters

USER 1001
