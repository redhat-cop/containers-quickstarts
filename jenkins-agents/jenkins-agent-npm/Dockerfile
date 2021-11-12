#invoke npm in jenkinsfile: sh "scl enable rh-nodejs6 'npm run build'"
FROM quay.io/openshift/origin-jenkins-agent-base:4.9

ARG JQ_VERSION=1.6
ARG OC_VERSION=4.8
ARG YQ_VERSION=4.6.3

ENV NODEJS_VERSION=12 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

RUN curl -sL https://rpm.nodesource.com/setup_${NODEJS_VERSION}.x | bash -

RUN INSTALL_PKGS="nodejs" && \
    dnf $DISABLE_REPOS install -y --setopt=tsflags=nodocs --disablerepo='rhel-*' \
      $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf clean all -y && \
    rm -rf /var/cache/yum && \
    npm install --unsafe-perm -g npm-audit-html npm-audit-ci-wrapper sonar-scanner || cat /home/jenkins/.npm/_logs/*-debug.log && \
    chown root:root /home/jenkins -R && \
    chmod 775 /home/jenkins/.config -R && \
    chmod 775 /home/jenkins/.npm -R && \
    curl -Lo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    curl -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    rm -f /usr/bin/oc && \
    curl -sL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-${OC_VERSION}/openshift-client-linux.tar.gz \
    | tar zxf - -C /usr/local/bin oc kubectl

USER 1001
