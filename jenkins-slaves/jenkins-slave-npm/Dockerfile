#invoke npm in jenkinsfile: sh "scl enable rh-nodejs6 'npm run build'"
FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7
USER root

ENV NODEJS_VERSION=8 \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    BASH_ENV=/usr/local/bin/scl_enable \
    ENV=/usr/local/bin/scl_enable \
    PROMPT_COMMAND=". /usr/local/bin/scl_enable"
COPY contrib/bin/scl_enable /usr/local/bin/scl_enable

RUN yum remove -y rh-nodejs4; \
    yum repolist > /dev/null && \
    INSTALL_PKGS="rh-nodejs8 rh-nodejs8-npm rh-nodejs8-nodejs-nodemon nss_wrapper redhat-lsb libXScrnSaver xdg-utils wget" && \
    yum install -y --setopt=tsflags=nodocs \
      --enablerepo=rhel-server-rhscl-7-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      --enablerepo=rhel-7-server-optional-rpms \
      --disablerepo=rhel-7-server-htb-rpms \
      $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    rm -rf /var/cache/yum

ADD https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm google-chrome-stable_current_x86_64.rpm
RUN yum -y localinstall google-chrome-stable_current_x86_64.rpm --disablerepo=rhel-7-server-htb-rpms
ENV CHROME_BIN /bin/google-chrome

USER 1001

RUN git config --global user.email "jenkins@redhat-cop.com" && \
    git config --global user.name "jenkins"
