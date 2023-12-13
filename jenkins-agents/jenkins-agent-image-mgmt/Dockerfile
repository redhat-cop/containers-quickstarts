FROM registry.access.redhat.com/ubi8/go-toolset:1.20.10-3@sha256:c78305ff7360bdacdd790225ca10478e08dd6fcbc037bcd176acdf4a552995da as builder

# renovate: datasource=github-releases depName=containers/skopeo
ARG SKOPEO_VERSION=v1.14.0

USER root

RUN curl -L https://github.com/containers/skopeo/archive/${SKOPEO_VERSION}.tar.gz | tar -C /tmp -zxf - && \
    mv /tmp/skopeo-${SKOPEO_VERSION//v} /tmp/skopeo && \
    cd /tmp/skopeo && \
    make BUILDTAGS=containers_image_openpgp DISABLE_DOCS=1 CGO_ENABLED=0 GO_DYN_FLAGS=

FROM quay.io/openshift/origin-jenkins-agent-base:4.14

# renovate: datasource=repology depName=homebrew/openshift-cli
ARG OC_VERSION=4.14.3

MAINTAINER Andrew Block <ablock@redhat.com>

LABEL com.redhat.component="jenkins-agent-image-mgmt" \
      name="jenkins-agent-image-mgmt" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Image Management" \
      io.k8s.description="Image management tools on top of the jenkins agent base image" \
      io.openshift.tags="openshift,jenkins,agent,copy"

USER root

RUN mkdir -p /etc/containers && \
    curl -L https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz | tar zxvf - -C /usr/bin oc

COPY --from=builder /tmp/skopeo/default-policy.json /etc/containers/policy.json
COPY --from=builder /tmp/skopeo/bin/skopeo /usr/bin/

USER 1001
