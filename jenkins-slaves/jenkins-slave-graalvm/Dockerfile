FROM openshift/jenkins-agent-maven-35-rhel7:latest
ARG GRAALVM_VERSION=19.3.1

ADD settings.xml $HOME/.m2/settings.xml


USER root
RUN yum install -y gcc glibc-devel zlib-devel libstdc++-static
RUN mkdir /opt/graalvm; \
    curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAALVM_VERSION}/graalvm-ce-java11-linux-amd64-${GRAALVM_VERSION}.tar.gz | tar --strip-components=1 -xz -C /opt/graalvm/; \
    /opt/graalvm/bin/gu install native-image
USER 1001
ENV GRAALVM_HOME /opt/graalvm
