# This dockerfile builds the zap stable release
FROM centos:centos7
LABEL maintainer="Deven Phillips <deven.phillips@redhat.com>"

RUN yum install -y epel-release && \
    yum clean all && \
    yum install -y redhat-rpm-config \
    make automake autoconf gcc gcc-c++ \
    libstdc++ libstdc++-devel \
    java-1.8.0-openjdk wget curl \
    xmlstarlet git x11vnc gettext tar \
    xorg-x11-server-Xvfb openbox xterm \
    net-tools python-pip \
    firefox nss_wrapper java-1.8.0-openjdk-headless \
    java-1.8.0-openjdk-devel nss_wrapper git && \
    yum clean all && \
    pip install --upgrade pip && \
    pip install zapcli && \
    pip install python-owasp-zap-v2.4 && \
    mkdir -p /zap/wrk && \
    mkdir -p /var/lib/jenkins/.vnc

ADD zap /zap/

# Copy the entrypoint
COPY configuration/* /var/lib/jenkins/
COPY configuration/run-jnlp-client /usr/local/bin/run-jnlp-client

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/ \
    PATH $JAVA_HOME/bin:/zap:$PATH \
    ZAP_PATH /zap/zap.sh \
    HOME /var/lib/jenkins \
    ZAP_PORT 8080

COPY policies /var/lib/jenkins/.ZAP/policies/
COPY .xinitrc /var/lib/jenkins/

WORKDIR /zap
# Download and expand the latest stable release 
RUN curl -s https://raw.githubusercontent.com/zaproxy/zap-admin/master/ZapVersions-dev.xml | xmlstarlet sel -t -v //url |grep -i Linux | wget -q --content-disposition -i - -O - | tar zx --strip-components=1 && \
    curl -s -L https://bitbucket.org/meszarv/webswing/downloads/webswing-2.3-distribution.zip | jar -x && \
    touch AcceptedLicense && \
    chown root:root /zap -R && \
    chown root:root -R /var/lib/jenkins && \
    chmod 777 /var/lib/jenkins -R && \
    chmod 777 /zap -R

ADD webswing.config /zap/webswing-2.3/webswing.config

WORKDIR /var/lib/jenkins

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/local/bin/run-jnlp-client"]
