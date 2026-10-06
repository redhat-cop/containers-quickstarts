FROM registry.access.redhat.com/ubi10/ubi-minimal:10.2-1790753097@sha256:204e1531cee54562b107fb31e0b327062fc3d5d67af7cc0d2e66b2c572b9044f

LABEL name="ubi10-git" \
      maintainer="Red Hat Services" \
      summary="Git on UBI 10 minimal" \
      description="Minimal UBI 10 image with git. Runs as non-root for CI and local use." \
      io.k8s.description="Git on UBI 10 minimal" \
      io.k8s.display-name="ubi10-git" \
      io.openshift.tags="git,ubi10,minimal" \
      org.opencontainers.image.title="ubi10-git" \
      org.opencontainers.image.description="Minimal UBI 10 image with git. Runs as non-root for CI and local use." \
      org.opencontainers.image.vendor="Red Hat Community of Practice" \
      org.opencontainers.image.base.name="registry.access.redhat.com/ubi10/ubi-minimal:10.2-1790753097"

RUN microdnf install -y --nodocs --setopt=install_weak_deps=0 git \
    && microdnf clean all \
    && rm -rf /var/cache /var/log/dnf* /var/log/yum* /tmp/* \
    && mkdir -p /home/git/tmp \
    && echo "git:x:1001:0:Git:/home/git:/bin/bash" >> /etc/passwd \
    && chown -R 1001:0 /home/git \
    && chmod -R g=u /home/git

ENV HOME=/home/git \
    TMPDIR=/home/git/tmp

WORKDIR /home/git

USER 1001

CMD ["git", "--version"]
