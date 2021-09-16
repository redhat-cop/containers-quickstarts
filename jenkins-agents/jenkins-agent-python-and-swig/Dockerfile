FROM quay.io/openshift/origin-jenkins-agent-base:4.5

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
      httpd24-mod_session atlas-devel gcc-gfortran libffi-devel libtool-ltdl enchant mariadb-devel \
      gcc-c++" && \
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

# installing Swig (for binding Python to C++) separately, as it is not currently
# available among the UBI packages:
# https://access.redhat.com/articles/4238681#ajax-reply-comment-1775201
RUN yum -y --setopt=tsflags=nodocs --disablerepo='rhel-*' install \
    http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/swig-3.0.12-19.module_el8.3.0+557+3d058e38.x86_64.rpm

RUN yum -y --setopt=tsflags=nodocs --disablerepo='rhel-*' install \
    http://mirror.centos.org/centos/8/AppStream/x86_64/os/Packages/gcc-toolset-9-runtime-9.0-4.el8.x86_64.rpm

USER 1001
