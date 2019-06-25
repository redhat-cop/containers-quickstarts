FROM openshift/jenkins-slave-base-centos7:v3.11

ENV RUBY_VERSION=2.5 \
  RUBY_SHORT_VERSION=25

ENV SUMMARY="Platform for building and running Ruby $RUBY_VERSION applications" \
    DESCRIPTION="Ruby $RUBY_VERSION available as docker container is a base platform for \
building and running various Ruby $RUBY_VERSION applications and frameworks. \
Ruby is the interpreted scripting language for quick and easy object-oriented programming. \
It has many features to process text files and to do system management tasks (as in Perl). \
It is simple, straight-forward, and extensible." \
  BASH_ENV=/opt/app-root/etc/scl_enable \
  ENV=/opt/app-root/etc/scl_enable \
  PATH=$PATH:/home/jenkins/bin \
  PROMPT_COMMAND=". /opt/app-root/etc/scl_enable" \
  HOME=/home/jenkins \
  ORIGIN_CLIENT=https://mirror.openshift.com/pub/openshift-v3/clients/3.11.50/linux/oc.tar.gz


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

RUN yum install -y centos-release-scl && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    INSTALL_PKGS="rh-ruby$RUBY_SHORT_VERSION rh-ruby$RUBY_SHORT_VERSION-ruby-devel rh-ruby$RUBY_SHORT_VERSION-rubygem-rake rh-ruby$RUBY_SHORT_VERSION-rubygem-bundler rh-nodejs6 autoconf automake" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    yum remove -y origin-clients && \
    yum clean all -y

RUN curl $ORIGIN_CLIENT | tar -C /usr/local/bin/ -xzf - && \
    chmod +x /usr/local/bin/oc

# Copy extra files to the image.
COPY ./root/ /

RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root
