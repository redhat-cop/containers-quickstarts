FROM rhel7-atomic

MAINTAINER Andrew Block <ablock@redhat.com>

LABEL io.k8s.description="Platform for building Play Framework Applications" \
    io.k8s.display-name="Play Framework" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,webserver,html,play" \
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
    io.openshift.s2i.destination="/opt/app-root"
    
ENV ACTIVATOR_VERSION=1.3.10 \
    HOME=/opt/app-root/src

COPY s2i /usr/libexec/s2i

RUN INSTALL_PKGS="tar unzip bc which lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
    microdnf --disablerepo rhel-7-server-htb-rpms && \
    microdnf install -y $INSTALL_PKGS && \
    microdnf update && \
    microdnf clean all && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
        -c "Default Application User" default && \
    mkdir -p ${HOME} /opt/activator /opt/s2i/destination/src/ /deployments && \
    chown -R 1001:0 /opt/app-root /opt/activator /opt/s2i/destination/src/ /deployments && \
    chmod -R "a+rwX" /deployments && \
    curl -o /tmp/typesafe-activator-${ACTIVATOR_VERSION}.zip https://downloads.typesafe.com/typesafe-activator/${ACTIVATOR_VERSION}/typesafe-activator-${ACTIVATOR_VERSION}.zip && \
    unzip /tmp/typesafe-activator-${ACTIVATOR_VERSION}.zip -d /tmp && \
    mv /tmp/activator-dist-${ACTIVATOR_VERSION}/* /opt/activator && \
    chown -R 1001:0 /opt/activator && \
    rm -rf /tmp/typesafe-activator-${ACTIVATOR_VERSION}.zip /tmp/activator-dist-${ACTIVATOR_VERSION}
            
ENV PATH $PATH:/opt/activator/bin

EXPOSE 8080

USER 1001

WORKDIR ${HOME}
