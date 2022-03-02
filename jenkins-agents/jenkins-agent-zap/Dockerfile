FROM quay.io/centos/centos:centos7
LABEL maintainer="Deven Phillips <deven.phillips@redhat.com>"

ARG ZAPROXY_VERSION="2.9.0"
ARG WEBSWING_VERSION="2.5.10"

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
    java-1.8.0-openjdk-devel nss_wrapper && \
    yum clean all && \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py && chmod 755 get-pip.py && ./get-pip.py && \
    pip install --upgrade pip && \
    pip install zapcli && \
    pip install python-owasp-zap-v2.4 && \
    mkdir -p /zap/{wrk,webswing} && \
    mkdir -p /var/lib/jenkins/.vnc

# Copy the entrypoint
COPY configuration/* /var/lib/jenkins/
COPY configuration/run-jnlp-client /usr/local/bin/run-jnlp-client

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/ \
    PATH=$JAVA_HOME/bin:/zap:$PATH \
    ZAP_PATH=/zap/zap.sh \
    HOME=/var/lib/jenkins \
    ZAP_PORT=8080

COPY .xinitrc /var/lib/jenkins/

WORKDIR /zap
RUN curl -sL https://github.com/zaproxy/zaproxy/releases/download/v${ZAPROXY_VERSION}/ZAP_${ZAPROXY_VERSION}_Linux.tar.gz | tar zx --strip-components=1 && \
    curl -sL https://bitbucket.org/meszarv/webswing/get/${WEBSWING_VERSION}.tar.gz | tar zx --strip-components=1 -C webswing && \
    rm -rf webswing/demo && \
    touch AcceptedLicense && \
    git clone --depth 1 --branch v${ZAPROXY_VERSION} https://github.com/zaproxy/zaproxy /tmp/zaproxy && \
    rsync -av /tmp/zaproxy/docker/{policies,scripts,zap*} /zap/ && \
    rsync -av /tmp/zaproxy/docker/policies /var/lib/jenkins/.ZAP/ && \
    rsync -av /tmp/zaproxy/docker/webswing.config /zap/webswing/webswing.config && \
    rm -rf /tmp/zaproxy && \
    touch /.dockerenv && \
    chown root:root /zap -R && \
    chown root:root -R /var/lib/jenkins && \
    chmod 777 /var/lib/jenkins -R && \
    chmod 777 /zap -R

WORKDIR /var/lib/jenkins

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/local/bin/run-jnlp-client"]
