FROM quay.io/openshift/origin-jenkins-agent-base:4.6

ARG RUBY_VERSION=2.6
ARG OC_VERSION=4.4

ENV SUMMARY="Platform for building and running Ruby $RUBY_VERSION applications" \
    DESCRIPTION="Ruby $RUBY_VERSION available as docker container is a base platform for \
building and running various Ruby $RUBY_VERSION applications and frameworks. \
Ruby is the interpreted scripting language for quick and easy object-oriented programming. \
It has many features to process text files and to do system management tasks (as in Perl). \
It is simple, straight-forward, and extensible." \
    PATH=$PATH:/home/jenkins/bin \
    HOME=/home/jenkins


LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Ruby $RUBY_VERSION" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,ruby,ruby$RUBY_SHORT_VERSION,rh-ruby$RUBY_SHORT_VERSION" \
      com.redhat.component="rh-ruby$RUBY_SHORT_VERSION-docker" \
      name="centos/ruby-$RUBY_SHORT_VERSION-centos7" \
      version="$RUBY_VERSION" \
      release="1" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

ADD ubi8.repo /tmp/ubi8.repo

RUN rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d/ubi8.repo && \
    dnf -y -x filesystem distro-sync && \
    dnf -y module list ruby && \
    dnf -y module reset ruby && \
    dnf -y module enable ruby:${RUBY_VERSION} && \
    dnf --allowerasing -y -x filesystem distro-sync && \
    dnf -y module install ruby:${RUBY_VERSION} && \
    INSTALL_PKGS="ruby ruby-devel rubygem-rake rubygem-bundler autoconf automake" && \
    dnf install -y --setopt=tsflags=nodocs $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    dnf remove -y origin-clients && \
    dnf clean all -y && \
    rm -rf /var/cache/dnf

RUN curl -L https://mirror.openshift.com/pub/openshift-v4/clients/oc/${OC_VERSION}/linux/oc.tar.gz | tar -C /usr/local/bin -xzf - && \
    chmod +x /usr/local/bin/oc

# Copy extra files to the image.
COPY ./root/ /

RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

WORKDIR /opt/app-root
