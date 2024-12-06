FROM registry.access.redhat.com/ubi8/ubi:8.10-1132.1732635159@sha256:79d46e7029c2b13a713b2089650fd235aadb3e6e449c79f6741d6c9381ab41a1

LABEL maintainer="Red Hat Services"

RUN dnf update -y && \
    dnf install -y --nodocs git && \
    dnf clean all
