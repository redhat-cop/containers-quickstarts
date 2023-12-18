FROM registry.access.redhat.com/ubi8/ubi:8.9@sha256:449da7f8f2ef6285a8445a1e31af57a97b9dae5dcf009b1629c59742c89c68c3

LABEL maintainer="Red Hat Services"

RUN dnf update -y && \
    dnf install -y --nodocs git && \
    dnf clean all
