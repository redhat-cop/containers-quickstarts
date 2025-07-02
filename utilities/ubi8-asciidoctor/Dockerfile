FROM registry.access.redhat.com/ubi8:latest@sha256:244e9858f9d8a2792a3dceb850b4fa8fdbd67babebfde42587bfa919d5d1ecef

LABEL MAINTAINERS="Red Hat Services"

ARG ARCH=amd64
ARG RUBY_VERSION=3.3
ARG asciidoctor_version=2.0.23
ARG asciidoctor_confluence_version=0.0.2
ARG asciidoctor_pdf_version=2.3.19
ARG asciidoctor_diagram_version=2.3.2
ARG asciidoctor_epub3_version=2.2.0
ARG asciidoctor_mathematical_version=0.3.5
ARG asciidoctor_revealjs_version=5.2.0
ARG kramdown_asciidoc_version=2.1.0
ARG asciidoctor_bibtex_version=0.9.0
ARG pandoc_version=3.6.4
ARG asciidoctor_reducer_version=1.1.2
ARG epubcheck_ruby_version=5.2.1.0


ENV ASCIIDOCTOR_VERSION=${asciidoctor_version} \
    ASCIIDOCTOR_CONFLUENCE_VERSION=${asciidoctor_confluence_version} \
    ASCIIDOCTOR_PDF_VERSION=${asciidoctor_pdf_version} \
    ASCIIDOCTOR_DIAGRAM_VERSION=${asciidoctor_diagram_version} \
    ASCIIDOCTOR_EPUB3_VERSION=${asciidoctor_epub3_version} \
    ASCIIDOCTOR_MATHEMATICAL_VERSION=${asciidoctor_mathematical_version} \
    ASCIIDOCTOR_REVEALJS_VERSION=${asciidoctor_revealjs_version} \
    KRAMDOWN_ASCIIDOC_VERSION=${kramdown_asciidoc_version} \
    ASCIIDOCTOR_BIBTEX_VERSION=${asciidoctor_bibtex_version} \
    PANDOC_VERSION=${pandoc_version} \
    ASCIIDOCTOR_REDUCER_VERSION=${asciidoctor_reducer_version} \
    EPUBCHECK_RUBY_VERSION=${epubcheck_ruby_version}

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
    python3-lxml \
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
    epubcheck-ruby:${EPUBCHECK_RUBY_VERSION} \
    haml \
    "kramdown-asciidoc:${KRAMDOWN_ASCIIDOC_VERSION}" \
    rouge \
    slim \
    thread_safe \
    tilt \
    "asciidoctor-bibtex:${ASCIIDOCTOR_BIBTEX_VERSION}" \
    "asciidoctor-reducer:${ASCIIDOCTOR_REDUCER_VERSION}" \
    && rm -rf /usr/local/share/gems/cache \
    && dnf clean all \
    && rm -rf /var/lib/dnf

# install pandoc
RUN curl -L https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-${ARCH}.tar.gz | tar xvz --strip-components 1 -C /usr/local/ pandoc-${PANDOC_VERSION}/bin/pandoc

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
       seqdiag \
       lxml

USER 1001

CMD ["/bin/bash"]
