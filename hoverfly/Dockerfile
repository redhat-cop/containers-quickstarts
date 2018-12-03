FROM registry.access.redhat.com/rhel7/rhel

ENV HOVERFLY_DOWNLOAD_URI https://github.com/SpectoLabs/hoverfly/releases/download/v0.17.4/hoverfly_bundle_linux_amd64.zip
ENV HOME /home/hoverfly

RUN PACKAGE_LIST="less unzip" && \
    yum install -y --disablerepo=* --enablerepo=rhel-7-server-rpms $PACKAGE_LIST && \
    rpm -V $PACKAGE_LIST && \
    yum clean all -y && \
    curl -o /tmp/hoverfly.zip -L $HOVERFLY_DOWNLOAD_URI && \
    unzip /tmp/hoverfly.zip -d /tmp/hoverfly && \
    mv /tmp/hoverfly/hover* /usr/bin && \
    rm -r /tmp/hoverfly /tmp/hoverfly.zip && \
    mkdir -m 775 $HOME && \
    chmod 775 /etc/passwd

WORKDIR $HOME

ADD ./s2i /usr/libexec/s2i

USER 1001

EXPOSE 8500 8888

CMD ["/usr/libexec/s2i/run"]
