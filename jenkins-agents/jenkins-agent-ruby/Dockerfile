FROM ghcr.io/redhat-cop/containers-quickstarts/jenkins-agent:v4.18@sha256:dea5725239100bc45183fa4ee4eb3efe519bd194325d1de9f6c6bac817613b23

LABEL name="redhat-cop/jenkins-agent-ruby" \
      io.k8s.display-name="Jenkins Agent Ruby" \
      io.k8s.description="The jenkins agent ruby." \
      com.redhat.component="redhat-cop/containers-quickstarts/jenkins-agent-ruby"

# renovate: datasource=repology depName=ubi_8/ruby
ARG RUBY_VERSION=3.1.2

USER root

RUN dnf -y module enable ruby:${RUBY_VERSION%.*} && \
    dnf install --nodocs -y ruby ruby-devel rubygem-rake rubygem-bundler libyaml-devel autoconf automake gcc make redhat-rpm-config && \
    dnf clean all -y

# Copy extra files to the image.
COPY ./root/ /
RUN chown -R 1001:0 /opt/app-root && \
    chmod -R ug+rwx /opt/app-root

USER 1001

WORKDIR /opt/app-root

RUN ruby -v