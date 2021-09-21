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
      gcc-c++" && \
    rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d && \
    dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf -y clean all && \
    alternatives --set python3 /usr/bin/python3.8 && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install twine

# installing Swig (for binding Python to C++) separately, as it is not currently
# available among the UBI packages:
# https://access.redhat.com/articles/4238681#ajax-reply-comment-1775201
RUN yum -y --setopt=tsflags=nodocs --disablerepo='rhel-*' install \
    http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/swig-3.0.12-19.module_el8.3.0+557+3d058e38.x86_64.rpm

USER 1001
