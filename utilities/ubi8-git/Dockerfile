FROM registry.access.redhat.com/ubi8/ubi:8.9-1160.1715068735@sha256:83068ea81dd02717b8e39b55cdeb2c1b2c9a3db260f01381b991755d44b15073

LABEL maintainer="Red Hat Services"

RUN dnf update -y && \
    dnf install -y --nodocs git && \
    dnf clean all
