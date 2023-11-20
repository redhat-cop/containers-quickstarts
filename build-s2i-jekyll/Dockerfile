FROM ruby:2.7.8-alpine@sha256:371668748735a808d1fd1c506878e09f40cb542ffc758cfa7eb124f90827e8d9

LABEL io.k8s.description="A Platform for Building Websites from Markdown" \
    io.k8s.display-name="Jekyll Builder" \
    io.openshift.tags="builder,ruby,nodejs" \
    io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
    io.openshift.s2i.destination="/tmp"

RUN apk add --no-cache --update \
    make \
    gcc \
    libc-dev \
    python \
    ;

COPY s2i /usr/local/s2i
ADD README.md /usr/local/s2i/usage.txt
RUN chgrp -R 0 /usr/local/s2i; \
    chmod -R 775 /usr/local/s2i; \
    chown -R 1001 /usr/local/s2i

WORKDIR /opt/jekyll

EXPOSE 4000

USER 1001

CMD [ "/usr/local/s2i/run" ]
