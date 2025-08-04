FROM quay.io/redhat-cop/python-kopf-s2i:latest@sha256:cc0b00f324a277dc27a654d3d53189e4cb86f7b65a8ec77b31a108fdc6195276

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
