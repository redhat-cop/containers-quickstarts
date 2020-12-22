FROM quay.io/openshift/origin-jenkins-agent-maven:4.6
ARG GRAALVM_VERSION=20.2.0

ADD settings.xml $HOME/.m2/settings.xml
ADD ubi8.repo /tmp/ubi8.repo

USER root
RUN rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d/ubi8.repo && \
    dnf install -y gcc glibc-devel zlib-devel && \
    mkdir /opt/graalvm && \
    curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz | tar --strip-components=1 -xz -C /opt/graalvm/ && \
    /opt/graalvm/bin/gu install native-image
USER 1001
ENV GRAALVM_HOME /opt/graalvm
ENV PATH /opt/rh/rh-maven35/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/graalvm/bin
