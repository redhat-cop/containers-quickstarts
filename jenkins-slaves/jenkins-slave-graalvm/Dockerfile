FROM quay.io/openshift/origin-jenkins-agent-maven:4.2
ADD settings.xml $HOME/.m2/settings.xml

ARG GRAALVM_VERSION=19.2.1

USER root
WORKDIR /opt
RUN mkdir /opt/graalvm
RUN curl -L https://github.com/oracle/graal/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-linux-amd64-${GRAALVM_VERSION}.tar.gz | tar -xz --strip-components=1 -C graalvm/
RUN graalvm/bin/gu install native-image
USER 1001
ENV GRAALVM_HOME /opt/graalvm
