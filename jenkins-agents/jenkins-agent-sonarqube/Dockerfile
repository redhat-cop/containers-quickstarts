FROM quay.io/openshift/origin-jenkins-agent-maven:4.4

USER root

ENV NODEJS_VERSION=10 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable
COPY contrib/bin/configure-agent /usr/local/bin/configure-agent

# Install NodeJS
RUN INSTALL_PKGS="rh-nodejs${NODEJS_VERSION} rh-nodejs${NODEJS_VERSION}-nodejs-nodemon make gcc-c++" && \
    ln -s /usr/lib/node_modules/nodemon/bin/nodemon.js /usr/bin/nodemon && \
    yum install -y --setopt=tsflags=nodocs --disableplugin=subscription-manager $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

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
