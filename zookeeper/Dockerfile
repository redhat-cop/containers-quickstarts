FROM rhel:7.2

ENV ZK_USER=zookeeper \
    ZK_DATA_DIR=/var/lib/zookeeper/data \
    ZK_DATA_LOG_DIR=/var/lib/zookeeper/log \
    ZK_LOG_DIR=/var/log/zookeeper \
    JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk \
    ZK_DIST=zookeeper-3.4.9

COPY fix-permissions /usr/local/bin

RUN INSTALL_PKGS="gettext tar zip unzip hostname nmap-ncat java-1.8.0-openjdk" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all  && \
    curl -fsSL http://www.apache.org/dist/zookeeper/$ZK_DIST/$ZK_DIST.tar.gz | tar xzf - -C /opt && \
    /usr/local/bin/fix-permissions /opt/$ZK_DIST && \
    ln -s /opt/$ZK_DIST /opt/zookeeper && \
    rm -rf /opt/zookeeper/CHANGES.txt \
        /opt/zookeeper/README.txt \
        /opt/zookeeper/NOTICE.txt \
        /opt/zookeeper/CHANGES.txt \
        /opt/zookeeper/README_packaging.txt \
        /opt/zookeeper/build.xml \
        /opt/zookeeper/config \
        /opt/zookeeper/contrib \
        /opt/zookeeper/dist-maven \
        /opt/zookeeper/docs \
        /opt/zookeeper/ivy.xml \
        /opt/zookeeper/ivysettings.xml \
        /opt/zookeeper/recipes \
        /opt/zookeeper/src \
        /opt/zookeeper/$ZK_DIST.jar.asc \
        /opt/zookeeper/$ZK_DIST.jar.md5 \
        /opt/zookeeper/$ZK_DIST.jar.sha1

COPY zkGenConfig.sh zkOk.sh zkMetrics.sh /opt/zookeeper/bin/

RUN useradd -u 1001 -r -c "Zookeeper User" $ZK_USER && \
    mkdir -p $ZK_DATA_DIR $ZK_DATA_LOG_DIR $ZK_LOG_DIR /usr/share/zookeeper /tmp/zookeeper && \
    chown -R 1001:0 $ZK_DATA_DIR $ZK_DATA_LOG_DIR $ZK_LOG_DIR /tmp/zookeeper && \
    /usr/local/bin/fix-permissions $ZK_DATA_DIR && \
    /usr/local/bin/fix-permissions $ZK_DATA_LOG_DIR && \
    /usr/local/bin/fix-permissions $ZK_LOG_DIR && \
    /usr/local/bin/fix-permissions /tmp/zookeeper

WORKDIR "/opt/zookeeper"

USER 1001