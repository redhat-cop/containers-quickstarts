#invoke npm in jenkinsfile: sh "scl enable rh-nodejs6 'npm run build'"
FROM openshift/jenkins-slave-base-centos7:v3.11

ENV NODEJS_VERSION=10 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    CHROME_BIN=/bin/google-chrome

RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm && \
    curl --silent --location https://rpm.nodesource.com/setup_${NODEJS_VERSION}.x | bash -

RUN INSTALL_PKGS="nodejs redhat-lsb libXScrnSaver xdg-utils liberation-fonts" && \
    yum install -y --setopt=tsflags=nodocs \
      $INSTALL_PKGS && \
    yum -y localinstall \
      google-chrome-stable_current_x86_64.rpm && \
    rm google-chrome-stable_current_x86_64.rpm && \
    rpm -V $INSTALL_PKGS google-chrome-stable && \
    yum clean all -y && \
    rm -rf /var/cache/yum && \
    npm install --unsafe-perm -g npm-audit-html npm-audit-ci-wrapper sonar-scanner || cat /home/jenkins/.npm/_logs/*-debug.log && \
    chown root:root /home/jenkins -R && \
    chmod 775 /home/jenkins/.config -R && \
    chmod 775 /home/jenkins/.npm -R

USER 1001
