FROM openshift/jenkins-slave-base-centos7

ENV RUBY_VERSION 2.4

ENV SUMMARY="Platform for building and running Ruby $RUBY_VERSION applications" \
    DESCRIPTION="Ruby $RUBY_VERSION available as docker container is a base platform for \
building and running various Ruby $RUBY_VERSION applications and frameworks. \
Ruby is the interpreted scripting language for quick and easy object-oriented programming. \
It has many features to process text files and to do system management tasks (as in Perl). \
It is simple, straight-forward, and extensible."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Ruby 2.4" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,ruby,ruby24,rh-ruby24" \
      com.redhat.component="rh-ruby24-docker" \
      name="centos/ruby-24-centos7" \
      version="2.4" \
      release="1" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>"

RUN yum install -y centos-release-scl && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    INSTALL_PKGS="rh-ruby24 rh-ruby24-ruby-devel rh-ruby24-rubygem-rake rh-ruby24-rubygem-bundler rh-nodejs6" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Copy extra files to the image.
COPY ./root/ /

ENV BASH_ENV=/opt/app-root/etc/scl_enable \
  ENV=/opt/app-root/etc/scl_enable \
  PROMPT_COMMAND=". /opt/app-root/etc/scl_enable"

RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
