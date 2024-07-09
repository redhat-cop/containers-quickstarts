FROM registry.access.redhat.com/ubi8/ubi:8.10-1020@sha256:44d75007b39e0e1bbf1bcfd0721245add54c54c3f83903f8926fb4bef6827aa2

LABEL maintainer="Red Hat Services"

RUN dnf update -y && \
    dnf install -y --nodocs git && \
    dnf clean all
