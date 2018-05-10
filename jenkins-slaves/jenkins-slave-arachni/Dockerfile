FROM openshift/jenkins-slave-base-centos7:latest

ARG VERSION=1.5.1
ARG WEB_VERSION=0.5.12

RUN yum install --disablerepo=rhel-7-server-htb-rpms -y wget ca-certificates

WORKDIR /arachni

RUN wget -qO- https://github.com/Arachni/arachni/releases/download/v${VERSION}/arachni-${VERSION}-${WEB_VERSION}-linux-x86_64.tar.gz | tar xvz -C /arachni --strip-components=1

EXPOSE 9292

COPY reporters ./system/gems/gems/arachni-${VERSION}/components/reporters

USER root

RUN chown -R root:root /arachni && \
    chmod -R 775 /arachni

USER 1001
