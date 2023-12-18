# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.3-1476@sha256:fc300be6adbdf2ca812ad01efd0dee2a3e3f5d33958ad6cd99159e25e9ee1398  AS builder

# renovate: datasource=repology depName=homebrew/openshift-cli
ARG OC_VERSION=4.14.5
RUN curl -L "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz" -o /tmp/openshift-client-linux.tar.gz && \
    tar --no-same-owner -xzf /tmp/openshift-client-linux.tar.gz && \
    mv oc kubectl /usr/local/bin && \
    oc version --client && \
    kubectl version --client

# Runnable
FROM quay.io/openshift/origin-jenkins-agent-base:4.14@sha256:1284ffe5b63ee7da4c4463d5f44b471fd42ce01c06f5c72edc195a30dcc1f7f4

LABEL name="redhat-cop/jenkins-agent" \
      io.k8s.display-name="Jenkins Agent Base" \
      io.k8s.description="The jenkins agent base." \
      io.openshift.tags="openshift,jenkins,agent,ansible" \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent" \
      release="1" \
      architecture="x86_64" \
      maintainer="github.com/redhat-cop"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

USER root

RUN rm -f /etc/yum.repos.d/*.repo
COPY ubi8.repo /etc/yum.repos.d/ubi8.repo

RUN dnf -y update && \
    dnf clean all

COPY --from=builder /usr/local/bin/oc /usr/local/bin/oc
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl

USER 1001

RUN oc version --client && \
    kubectl version --client