FROM registry.access.redhat.com/ubi8:latest

LABEL MAINTAINERS="Red Hat Services"

ARG RUBY_VERSION=2.7
ARG asciidoctor_version=2.0.16
ARG asciidoctor_confluence_version=0.0.2
ARG asciidoctor_pdf_version=1.6.1
ARG asciidoctor_diagram_version=2.2.1
ARG asciidoctor_epub3_version=1.5.1
ARG asciidoctor_mathematical_version=0.3.5
ARG asciidoctor_revealjs_version=4.1.0
ARG kramdown_asciidoc_version=2.0.0
ARG asciidoctor_bibtex_version=0.8.0
ARG pandoc_version=2.16.2


ENV ASCIIDOCTOR_VERSION=${asciidoctor_version} \
    ASCIIDOCTOR_CONFLUENCE_VERSION=${asciidoctor_confluence_version} \
    ASCIIDOCTOR_PDF_VERSION=${asciidoctor_pdf_version} \
    ASCIIDOCTOR_DIAGRAM_VERSION=${asciidoctor_diagram_version} \
    ASCIIDOCTOR_EPUB3_VERSION=${asciidoctor_epub3_version} \
    ASCIIDOCTOR_MATHEMATICAL_VERSION=${asciidoctor_mathematical_version} \
    ASCIIDOCTOR_REVEALJS_VERSION=${asciidoctor_revealjs_version} \
    KRAMDOWN_ASCIIDOC_VERSION=${kramdown_asciidoc_version} \
    ASCIIDOCTOR_BIBTEX_VERSION=${asciidoctor_bibtex_version} \
   PANDOC_VERSION=${pandoc_version}

USER root

RUN dnf -y module enable ruby:${RUBY_VERSION} && \
    dnf -y module install ruby:${RUBY_VERSION}

RUN dnf install -y \
    python3-devel \
    git \
    make \
    gcc \
    redhat-rpm-config \
    ruby-devel \
    zlib-devel \
    libjpeg-turbo-devel \
    java-11-openjdk-headless \
    fontconfig \
    && gem install --no-document \
    "asciidoctor:${ASCIIDOCTOR_VERSION}" \
    "asciidoctor-confluence:${ASCIIDOCTOR_CONFLUENCE_VERSION}" \
    "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}" \
    "asciidoctor-epub3:${ASCIIDOCTOR_EPUB3_VERSION}" \
    asciimath \
    "asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION}" \
    "asciidoctor-revealjs:${ASCIIDOCTOR_REVEALJS_VERSION}" \
    coderay \
    epubcheck-ruby:4.2.4.0 \
    haml \
    "kramdown-asciidoc:${KRAMDOWN_ASCIIDOC_VERSION}" \
    rouge \
    slim \
    thread_safe \
    tilt \
    "asciidoctor-bibtex:${ASCIIDOCTOR_BIBTEX_VERSION}" \
    && rm -rf /usr/local/share/gems/cache \
    && dnf clean all \
    && rm -rf /var/lib/dnf

# install pandoc
RUN curl -L https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz | tar xvz --strip-components 1 -C /usr/local/

WORKDIR /documents
VOLUME /documents

RUN mkdir /home/work \
    && chgrp -R 0 /home/work \
    && chmod -R g=u /home/work

ENV HOME=/home/work

# Installing Python dependencies for additional
# functionnalities as diagrams or syntax highligthing
RUN pip3 install --no-cache-dir \
       actdiag \
       'blockdiag[pdf]' \
       'nwdiag[pdf]' \
       seqdiag

USER 1001

CMD ["/bin/bash"]

