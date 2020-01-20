#FROM registry.redhat.io/openshift3/jenkins-slave-base-rhel7:v3.11
FROM docker.io/openshift/jenkins-slave-base-centos7:v3.11
USER root

ARG GRAAL_VERSION=19.0.2
ENV GRAALVM_HOME /opt/graalvm
ENV GRAAL_CE_URL=https://github.com/oracle/graal/releases/download/vm-${GRAAL_VERSION}/graalvm-ce-linux-amd64-${GRAAL_VERSION}.tar.gz

RUN mkdir -p ${GRAALVM_HOME} && \
     cd ${GRAALVM_HOME} && \
     curl -fsSL $GRAAL_CE_URL | tar -xzC ${GRAALVM_HOME} --strip-components=1  && \
     /opt/graalvm/bin/gu install native-image

# Labels consumed by Red Hat build service
LABEL com.redhat.component="jenkins-agent-maven-35-rhel7-container" \
      name="openshift3/jenkins-agent-maven-35-rhel7" \
      version="3.11" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Maven" \
      io.k8s.description="The jenkins agent maven image has the maven tools on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,agent,maven"

ENV MAVEN_VERSION=3.5 \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"

# Install Maven
RUN yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-server-rhscl-8-rpms && \
    yum-config-manager --disable epel >/dev/null || : && \
    INSTALL_PKGS="java-1.8.0-openjdk-devel rh-maven35* zlib-devel" && \
    x86_EXTRA_RPMS=$(if [ "$(uname -m)" == "x86_64" ]; then echo -n java-1.8.0-openjdk-devel.i686 ; fi) && \
    yum install --skip-broken -y $INSTALL_PKGS $x86_EXTRA_RPMS && \
    rpm -V java-1.8.0-openjdk-devel rh-maven35 $x86_EXTRA_RPMS && \
    yum clean all -y && \
    mkdir -p $HOME/.m2

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ADD contrib/bin/scl_enable /usr/local/bin/scl_enable
ADD contrib/bin/configure-agent /usr/local/bin/configure-agent
ADD settings.xml $HOME/.m2/settings.xml

RUN chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
