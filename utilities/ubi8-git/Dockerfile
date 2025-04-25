FROM registry.access.redhat.com/ubi8/ubi:8.10-1262@sha256:244e9858f9d8a2792a3dceb850b4fa8fdbd67babebfde42587bfa919d5d1ecef

LABEL maintainer="Red Hat Services"

RUN dnf update -y && \
    dnf install -y --nodocs git && \
    dnf clean all
