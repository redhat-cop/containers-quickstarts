FROM registry.access.redhat.com/ubi8@sha256:449da7f8f2ef6285a8445a1e31af57a97b9dae5dcf009b1629c59742c89c68c3

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

# Copy in custom helper scripts
add ./root /
RUN chmod u+x /usr/local/bin/upload-file-to-google-drive
