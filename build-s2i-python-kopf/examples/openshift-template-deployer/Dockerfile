FROM quay.io/redhat-cop/python-kopf-s2i:latest@sha256:c0a91e25a5089a4dda20919c6ce764e0e65d9767a2afccb796de0a4975041d73

USER root

COPY . /tmp/src

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src && \
    install -d /tmp/scripts && \
    cp /usr/libexec/s2i/run /tmp/scripts/run && \
    (cp /tmp/src/.s2i/bin/run /tmp/scripts/run || :)

USER 1001

RUN /usr/libexec/s2i/assemble

CMD ["/tmp/scripts/run"]
