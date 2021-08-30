FROM quay.io/openshift/origin-jenkins-agent-base:4.6

EXPOSE 8080

ENV PYTHON_VERSION=3.8 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

ADD ubi8.repo /tmp/ubi8.repo

RUN INSTALL_PKGS=" \
      python38 python38-devel nss_wrapper httpd httpd-devel mod_ssl mod_ldap \
      mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant \
      g++ libpcre3 libpcre3-dev locales" && \
    rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d && \
    dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf -y clean all && \
    alternatives --set python3 /usr/bin/python3.8 && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install twine

RUN wget https://prdownloads.sourceforge.net/swig/swig-3.0.12.tar.gz \
    && chmod 777 swig-3.0.12.tar.gz \
    && tar -xzvf swig-3.0.12.tar.gz \
    && cd swig-3.0.12 \
    && ./configure --prefix=/swig/swig \
    && make \
    && make install \
    && sed -i 's|export PATH|export SWIG_PATH=/swig/swig/bin\nexport PATH=$SWIG_PATH:$PATH |g' /etc/profile \
    && echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8

USER 1001
