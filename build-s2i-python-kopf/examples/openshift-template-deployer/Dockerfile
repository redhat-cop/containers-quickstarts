FROM quay.io/redhat-cop/python-kopf-s2i:latest@sha256:f9c2dd0afb36e251caae17223782d3faad51c631df740eea5ec92ef4f6a19afa

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
