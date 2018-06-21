#invoke npm in jenkinsfile: sh "scl enable rh-nodejs6 'npm run build'"
FROM openshift3/jenkins-slave-base-rhel7

ENV NODEJS_VERSION=8 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable" \
    CHROME_BIN=/bin/google-chrome

COPY contrib/bin/scl_enable /usr/local/bin/scl_enable
ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm google-chrome-stable_current_x86_64.rpm

RUN INSTALL_PKGS="rh-nodejs8 rh-nodejs8-npm rh-nodejs8-nodejs-nodemon nss_wrapper redhat-lsb libXScrnSaver xdg-utils" && \
    yum install -y --setopt=tsflags=nodocs \
      --disablerepo=* \
      --enablerepo=rhel-7-server-rpms \
      --enablerepo=rhel-server-rhscl-7-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      $INSTALL_PKGS && \
    yum -y localinstall \
      --disablerepo=* \
      --enablerepo=rhel-7-server-rpms \
      google-chrome-stable_current_x86_64.rpm && \
    rm google-chrome-stable_current_x86_64.rpm && \
    rpm -V $INSTALL_PKGS google-chrome-stable && \
    yum clean all -y && \
    rm -rf /var/cache/yum

USER 1001

