FROM registry.access.redhat.com/ubi7/ubi-minimal:7.9-1242@sha256:5ba8e7e3b99b12a3af91b603a6250a149dae865eaf19d4ee22f383f13a04a0fb

LABEL \
    io.k8s.display-name="Executable Applications" \
    io.k8s.description="Platform for building and running executable applications" \
    description="Source To Image (S2I) compatible image for running executable application" \
    io.openshift.tags="builder,executable" \
    io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
    io.openshift.s2i.destination="/tmp"

ENV RUNTIME_DIRECTORY="/app"

COPY s2i /usr/local/s2i

RUN INSTALL_PKGS="tar shadow-utils" && \ 
    microdnf --nodocs install $INSTALL_PKGS && \
    microdnf clean all && \
    groupadd -r default -g 185 && useradd -u 1001 -r -g root -G default -m -d /home/default -s /sbin/nologin -c "Default user" default && \
    mkdir -p $RUNTIME_DIRECTORY && \
    chmod -R "ug+rwX" $RUNTIME_DIRECTORY && \
    chown -R default:root $RUNTIME_DIRECTORY && \
    chmod 775 /usr/local/s2i && \
    chown -R default:root /usr/local/s2i

USER 1001

WORKDIR $RUNTIME_DIRECTORY

CMD ["/usr/local/s2i/run"]