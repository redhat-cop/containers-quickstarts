FROM registry.access.redhat.com/ubi8/go-toolset:latest as builder

ARG SKOPEO_VERSION=1.1.1

USER root

RUN curl -L https://github.com/containers/skopeo/archive/v${SKOPEO_VERSION}.tar.gz | tar -C /tmp -zxf - && \
    mv /tmp/skopeo-${SKOPEO_VERSION} /tmp/skopeo && \
    cd /tmp/skopeo && \
    make binary-local DISABLE_CGO=1

FROM quay.io/openshift/origin-jenkins-agent-base:4.7

MAINTAINER Andrew Block <ablock@redhat.com>

LABEL com.redhat.component="jenkins-agent-image-mgmt" \
      name="jenkins-agent-image-mgmt" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Image Management" \
      io.k8s.description="Image management tools on top of the jenkins agent base image" \
      io.openshift.tags="openshift,jenkins,agent,copy"

USER root

RUN mkdir -p /etc/containers

COPY --from=builder /tmp/skopeo/default-policy.json /etc/containers/policy.json
COPY --from=builder /tmp/skopeo/skopeo /usr/bin/

USER 1001
