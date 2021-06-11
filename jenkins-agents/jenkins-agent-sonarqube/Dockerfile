# FROM quay.io/openshift/origin-jenkins-agent-maven:4.4

# USER root

# ENV SONARQUBE_SCANNER_VERSION=3.2.0.1227 \
#     PATH=$PATH:/sonarqube-scanner/bin \
#     HOME=/home/jenkins \
#     BUILD_VERSION=b12

# COPY ubi.repo mongodb-org-3.6.repo /etc/yum.repos.d/

# RUN DISABLE_REPOS=--disablerepo='rhel-*' && \
#     set -x && \
#     curl https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip -o sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip && \
#     unzip sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip && \
#     rm sonar-scanner-cli-$SONARQUBE_SCANNER_VERSION-linux.zip && \
#     mv /sonar-scanner-$SONARQUBE_SCANNER_VERSION-linux /sonarqube-scanner

# RUN chown -R 1001:0 /usr/local/bin && \
#     chown -R 1001:0 $HOME && \
#     chmod -R g+rw $HOME

# USER 1001

FROM quay.io/openshift/origin-jenkins-agent-base:4.6

ENV NODEJS_VERSION=12 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

RUN curl --silent --location https://rpm.nodesource.com/setup_${NODEJS_VERSION}.x | bash -

RUN INSTALL_PKGS="nodejs" && \
    dnf $DISABLE_REPOS install -y --setopt=tsflags=nodocs --disablerepo='rhel-*' \
      $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf clean all -y && \
    rm -rf /var/cache/yum && \
    npm install --unsafe-perm -g npm-audit-html npm-audit-ci-wrapper sonar-scanner || cat /home/jenkins/.npm/_logs/*-debug.log && \
    chown root:root /home/jenkins -R && \
    chmod 775 /home/jenkins/.config -R && \
    chmod 775 /home/jenkins/.npm -R


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
