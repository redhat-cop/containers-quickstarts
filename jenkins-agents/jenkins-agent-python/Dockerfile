FROM quay.io/openshift/origin-jenkins-agent-base:4.16@sha256:9e63c022e118b87917bf4af8253f706ec5cde1c20be58fb1ad7b42a2a72b2023

EXPOSE 8080

ENV PYTHON_VERSION=3.9 \
    PATH=$HOME/.local/bin/:$PATH \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    PIP_NO_CACHE_DIR=off

ADD ubi8.repo /tmp/ubi8.repo

RUN INSTALL_PKGS=" \
      python39 python39-devel nss_wrapper httpd httpd-devel mod_ssl mod_ldap \
      mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant" && \
    rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d && \
    dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf -y clean all && \
    alternatives --set python3 /usr/bin/python3.9 && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install twine && \
    chmod -R 775 /var/lib/alternatives && \
    chmod -R 775 /etc/alternatives

USER 1001
