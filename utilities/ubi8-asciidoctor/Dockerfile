FROM registry.access.redhat.com/ubi8

LABEL MAINTAINERS="Red Hat Services"

ARG asciidoctor_version=2.0.10
ARG asciidoctor_confluence_version=0.0.2
ARG asciidoctor_pdf_version=1.5.3
ARG asciidoctor_diagram_version=2.0.1
ARG asciidoctor_epub3_version=1.5.0.alpha.18
ARG asciidoctor_mathematical_version=0.3.1
ARG asciidoctor_revealjs_version=4.0.1
ARG kramdown_asciidoc_version=1.0.1
ARG pandoc_version=2.10.1


ENV ASCIIDOCTOR_VERSION=${asciidoctor_version} \
  ASCIIDOCTOR_CONFLUENCE_VERSION=${asciidoctor_confluence_version} \
  ASCIIDOCTOR_PDF_VERSION=${asciidoctor_pdf_version} \
  ASCIIDOCTOR_DIAGRAM_VERSION=${asciidoctor_diagram_version} \
  ASCIIDOCTOR_EPUB3_VERSION=${asciidoctor_epub3_version} \
  ASCIIDOCTOR_MATHEMATICAL_VERSION=${asciidoctor_mathematical_version} \
  ASCIIDOCTOR_REVEALJS_VERSION=${asciidoctor_revealjs_version} \
  KRAMDOWN_ASCIIDOC_VERSION=${kramdown_asciidoc_version} \
  PANDOC_VERSION=${pandoc_version}


USER root

RUN dnf install -y \
  tar \
  gzip \
  python3 \
  python3-setuptools \
  git \
  ruby \
  && dnf clean all && rm -rf /var/lib/dnf && rm -rf /usr/share/doc

# install pandoc
RUN curl -L https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz | tar xvz --strip-components 1 -C /usr/local/

# Installing Ruby Gems needed in the image
# including asciidoctor itself
# TODO: have to find Lasem dev libs     "asciidoctor-mathematical:${ASCIIDOCTOR_MATHEMATICAL_VERSION}" \

RUN dnf install -y \
  make \
  cmake \
  ruby-devel \
  gcc redhat-rpm-config \
  zlib-devel \
  patch \
  gcc-c++ \
  glib2-devel \
  && gem install --no-document \
    "asciidoctor:${ASCIIDOCTOR_VERSION}" \
    "asciidoctor-confluence:${ASCIIDOCTOR_CONFLUENCE_VERSION}" \
    "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}" \
    "asciidoctor-epub3:${ASCIIDOCTOR_EPUB3_VERSION}" \
    asciimath \
    "asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION}" \
    "asciidoctor-revealjs:${ASCIIDOCTOR_REVEALJS_VERSION}" \
    coderay \
    epubcheck-ruby:4.2.2.0 \
    haml \
    "kramdown-asciidoc:${KRAMDOWN_ASCIIDOC_VERSION}" \
    rouge \
    slim \
    thread_safe \
    tilt \
  && rm -rf /usr/local/share/gems/cache \
  && dnf history undo last -y && dnf clean all && rm -rf /var/lib/dnf

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

