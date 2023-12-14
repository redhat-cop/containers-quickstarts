FROM registry.access.redhat.com/ubi8/ubi:8.9

LABEL maintainer="Red Hat Services"

RUN dnf update -y && \
    dnf install -y --nodocs git && \
    dnf clean all
