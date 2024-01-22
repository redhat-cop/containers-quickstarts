# Builder
FROM registry.access.redhat.com/ubi9/go-toolset:1.20.10-6@sha256:077f292da8bea9ce7f729489cdbd217dd268ce300f3e216cb1fffb38de7daeb9 AS builder

SHELL ["/bin/bash", "-c"]

USER root

# renovate: datasource=github-releases depName=containers/skopeo
ARG SKOPEO_VERSION=v1.14.1
RUN curl -L "https://github.com/containers/skopeo/archive/${SKOPEO_VERSION}.tar.gz" -o /tmp/skopeo.tar.gz && \
    tar -xzf /tmp/skopeo.tar.gz && \
    mv skopeo-${SKOPEO_VERSION//v} /skopeo && \
    pushd /skopeo && \
    make BUILDTAGS=containers_image_openpgp DISABLE_DOCS=1 CGO_ENABLED=0 GO_DYN_FLAGS=

USER 1001

# Runnable
FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.14

LABEL name="redhat-cop/jenkins-agent-image-mgmt" \
      io.k8s.display-name="Jenkins Agent Image Management" \
      io.k8s.description="Image management tools on top of the jenkins agent base image" \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-image-mgmt"

USER root

RUN mkdir -p /etc/containers
COPY --from=builder /skopeo/default-policy.json /etc/containers/policy.json
COPY --from=builder /skopeo/bin/skopeo /usr/local/bin/skopeo

USER 1001

RUN skopeo --version
