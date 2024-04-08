FROM registry.access.redhat.com/ubi8/ubi:8.9-1160@sha256:edc34f89cf9c818c2fb28b8ea1780f384db563ce4293dc0ab8e73ec01791e5af

LABEL maintainer="Red Hat Services"

RUN dnf update -y && \
    dnf install -y --nodocs git && \
    dnf clean all
