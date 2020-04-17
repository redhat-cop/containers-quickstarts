FROM ubi8

LABEL maintainer="Red Hat Services"

# Update image
RUN dnf update -y && rm -rf /var/cache/yum

# Install packages
RUN dnf install -y \
  git \
  && dnf clean all
