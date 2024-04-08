# Builder
FROM registry.access.redhat.com/ubi9/go-toolset:1.20.10-11@sha256:c7c3cf77133ff99b32e04ba1b6f238d15ed97403dae1a24e5b3f6ad82087f07e AS builder

SHELL ["/bin/bash", "-c"]

USER root

# renovate: datasource=github-releases depName=containers/skopeo
ARG SKOPEO_VERSION=v1.15.0
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
