FROM registry.access.redhat.com/ubi9/ubi-minimal:9.8-1790754119@sha256:1d7c5517a4a1a8e2688620b39ee980e82505ca1ab7ae5541b5463120ae9b3897

LABEL name="ubi9-git" \
      maintainer="Red Hat Services" \
      summary="Git on UBI 9 minimal" \
      description="Minimal UBI 9 image with git. Runs as non-root for CI and local use." \
      io.k8s.description="Git on UBI 9 minimal" \
      io.k8s.display-name="ubi9-git" \
      io.openshift.tags="git,ubi9,minimal" \
      org.opencontainers.image.title="ubi9-git" \
      org.opencontainers.image.description="Minimal UBI 9 image with git. Runs as non-root for CI and local use." \
      org.opencontainers.image.vendor="Red Hat Community of Practice" \
      org.opencontainers.image.base.name="registry.access.redhat.com/ubi9/ubi-minimal:9.8-1790754119"

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
