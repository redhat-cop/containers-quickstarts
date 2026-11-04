FROM registry.fedoraproject.org/fedora:latest

LABEL MAINTAINERS="Red Hat Services"

RUN dnf -y update && \
	dnf -y install asciidoctor pandoc python3-pip && \
	dnf clean all

RUN gem install asciidoctor-diagram asciidoctor-pdf kramdown-asciidoc rouge


# Installing Python dependencies for additional
# functionnalities as diagrams or syntax highligthing
RUN pip3 install --no-cache-dir \
       actdiag \
       'blockdiag[pdf]' \
       'nwdiag[pdf]' \
       seqdiag


WORKDIR /documents
VOLUME /documents

RUN mkdir /home/work \
    && chgrp -R 0 /home/work \
    && chmod -R g=u /home/work

ENV HOME=/home/work


USER 1001

CMD ["/bin/bash"]

