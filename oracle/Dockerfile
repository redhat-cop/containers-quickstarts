FROM oraclelinux

RUN INSTALL_PKGS="oracle-database-server-12cR2-preinstall " && \
    yum install --setopt=tsflags=nodocs -y $INSTALL_PKGS && \
    yum update -y && \
    yum clean all