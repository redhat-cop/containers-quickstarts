FROM registry.access.redhat.com/ubi8/ubi:8.10-1764070939@sha256:a444712276a635c9312d83a4ff7c6ee7f2ce08eeb5bd9ca291b5fdba257a5e63

LABEL maintainer="Red Hat Services"

RUN dnf update -y && \
    dnf install -y --nodocs git && \
    dnf clean all
