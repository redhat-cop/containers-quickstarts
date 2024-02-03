FROM registry.access.redhat.com/ubi8/ubi:8.9-1107.1706791207@sha256:627867e53ad6846afba2dfbf5cef1d54c868a9025633ef0afd546278d4654eac

LABEL maintainer="Red Hat Services"

RUN dnf update -y && \
    dnf install -y --nodocs git && \
    dnf clean all
