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

EXPOSE 8080

ENV PYTHON_VERSION=3.8 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

ADD ubi.repo /etc/yum.repos.d/ubi.repo

RUN INSTALL_PKGS=" \
      rh-python38 rh-python38-python-devel rh-python38-python-setuptools rh-python38-python-wheel rh-python38-python-pip nss_wrapper \
      httpd24 httpd24-httpd-devel httpd24-mod_ssl httpd24-mod_auth_kerb httpd24-mod_ldap \
      httpd24-mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant mariadb-devel" && \
    DISABLE_REPOS=--disablerepo='rhel-*' && \
    yum -y localinstall http://mirror.centos.org/centos/7/os/x86_64/Packages/libtirpc-0.2.4-0.16.el7.x86_64.rpm && \
    yum $DISABLE_REPOS install -y yum-utils && \
    yum -y --setopt=tsflags=nodocs $DISABLE_REPOS install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && \
    source scl_source enable rh-python38 && \
    scl enable rh-python38 bash && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install twine

ADD scl_enable /usr/share/container-scripts/

ENV BASH_ENV=/usr/share/container-scripts/scl_enable \
    ENV=/usr/share/container-scripts/scl_enable \
    PROMPT_COMMAND=". /usr/share/container-scripts/scl_enable"


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
