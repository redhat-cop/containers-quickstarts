FROM openshift/jenkins-2-centos7

LABEL com.redhat.component="jenkins-slave-zap-centos-docker" \
      name="openshift3/jenkins-slave-zap-centos" \
      version="3.11" \
      architecture="x86_64" \
      release="1" \
      io.k8s.display-name="Jenkins Slave ZAP" \
      io.k8s.description="The jenkins slave ZAP image has the OWASP Zed Attack Proxy on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,slave,zap,owasp"

USER root

ENV PATH /zap:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin
WORKDIR /zap
RUN curl -s https://raw.githubusercontent.com/zaproxy/zap-admin/master/ZapVersions-dev.xml | \
    grep "<url>" | grep ZAP | grep Linux | sed -e 's@^[^>]*>\([^<]*\).*$@\1@g' | xargs -n 1 curl -s -L -o zap.tar.gz && \
    tar --strip-components=1 -xzf zap.tar.gz && \
    rm -f zap.tar.gz && \
    touch AcceptedLicense

COPY policies /home/jenkins/.ZAP/policies/
COPY scripts /home/jenkins/.ZAP/scripts/
RUN chown root:root /home/jenkins -R; \
    chmod 770 /home/jenkins -R; \
    chown root:root /home/jenkins/.ZAP -R; \
    chmod 770 /home/jenkins/.ZAP -R; \ 
    chown root:root /zap; \
    chown 770 /zap -R

ENV ZAP_PATH /zap/zap.sh

USER 1001
