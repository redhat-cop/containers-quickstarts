FROM registry.access.redhat.com/rhscl/mariadb-101-rhel7

USER root

RUN yum clean all && \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    INSTALL_PKGS="rh-mariadb101-galera which" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

USER 27

ADD root /

EXPOSE 4567 4568 4444
