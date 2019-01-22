FROM redhatcop/gows:busybox

LABEL io.k8s.description="GoWS Web Server S2I Image" \
      io.k8s.display-name="GoWS Builder" \
      io.openshift.tags="builder,gows" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.s2i.destination="/opt/site"

COPY s2i /usr/local/s2i
RUN mkdir -p /opt/site;\
    chgrp -R 0 /opt/site; \
    chgrp -R 0 /usr/local/s2i; \
    chgrp 0 /bin/gows; \
    chmod -R 775 /opt/site; \
    chmod -R 775 /usr/local/s2i; \
    chmod 775 /bin/gows; \
    chown -R 1001 /usr/local/s2i; \
    chown -R 1001 /bin/gows

USER 1001

WORKDIR /opt/site

CMD [ "/usr/local/s2i/run" ]
