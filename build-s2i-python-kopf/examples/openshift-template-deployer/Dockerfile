FROM quay.io/redhat-cop/python-kopf-s2i:latest@sha256:2b8e2a4de228483805a6afa6fbdefd51a0e8e905d26ab33a5562eab0aeffb119

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
