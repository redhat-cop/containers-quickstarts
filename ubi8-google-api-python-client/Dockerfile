FROM registry.access.redhat.com/ubi8

LABEL maintainer="Red Hat Services"

# Update image
RUN dnf update -y && rm -rf /var/cache/yum

# Install packages
RUN dnf install -y \
  git \
  python36 \
  python3-pip \
  python3-numpy \
  python3-scipy \
  python3-setuptools \
  python3-six \
  && dnf clean all

# Install Python modules
RUN pip3 install --upgrade \
  pip \
  google-api-python-client \
  google-auth-httplib2 \
  google-auth-oauthlib \
  oauth2client
