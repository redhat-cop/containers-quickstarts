FROM registry.access.redhat.com/ubi8/go-toolset:latest as builder

ARG SKOPEO_VERSION=1.5.2

USER root

RUN curl -L https://github.com/containers/skopeo/archive/v${SKOPEO_VERSION}.tar.gz | tar -C /tmp -zxf - && \
    mv /tmp/skopeo-${SKOPEO_VERSION} /tmp/skopeo && \
    cd /tmp/skopeo && \
    make BUILDTAGS=containers_image_openpgp DISABLE_DOCS=1 CGO_ENABLED=0 GO_DYN_FLAGS=

FROM quay.io/openshift/origin-jenkins-agent-base:4.16@sha256:9e63c022e118b87917bf4af8253f706ec5cde1c20be58fb1ad7b42a2a72b2023

ARG OC_VERSION=4.9

MAINTAINER Andrew Block <ablock@redhat.com>

LABEL com.redhat.component="jenkins-agent-image-mgmt" \
      name="jenkins-agent-image-mgmt" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Image Management" \
      io.k8s.description="Image management tools on top of the jenkins agent base image" \
      io.openshift.tags="openshift,jenkins,agent,copy"

USER root

RUN mkdir -p /etc/containers && \
    curl -L https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-${OC_VERSION}/openshift-client-linux.tar.gz | tar zxvf - -C /usr/bin oc

COPY --from=builder /tmp/skopeo/default-policy.json /etc/containers/policy.json
COPY --from=builder /tmp/skopeo/bin/skopeo /usr/bin/

USER 1001
