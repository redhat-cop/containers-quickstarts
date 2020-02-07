FROM quay.io/openshift/origin-jenkins-agent-maven:4.2
ARG GRAALVM_VERSION=19.3.1

ADD settings.xml $HOME/.m2/settings.xml


USER root
RUN mkdir /opt/graalvm
RUN curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz | tar -xz -C /opt/graalvm/
RUN graalvm/bin/gu install native-image
USER 1001
ENV GRAALVM_HOME /opt/graalvm
