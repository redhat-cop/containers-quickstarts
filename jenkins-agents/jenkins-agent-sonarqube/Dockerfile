FROM quay.io/openshift/origin-jenkins-agent-maven:4.4

USER root

ENV SONARQUBE_SCANNER_VERSION=3.2.0.1227 \
    PATH=$PATH:/sonarqube-scanner/bin \
    HOME=/home/jenkins \
    BUILD_VERSION=b12

COPY ubi.repo mongodb-org-3.6.repo /etc/yum.repos.d/

RUN DISABLE_REPOS=--disablerepo='rhel-*' && \
    set -x && \
    curl https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip -o sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip && \
    unzip sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip && \
    rm sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip && \
    mv /sonar-scanner-$SONARQUBE_SCANNER_VERSION-linux /sonarqube-scanner

RUN chown -R 1001:0 /usr/local/bin && \
    chown -R 1001:0 $HOME && \
    chmod -R g+rw $HOME

USER 1001
