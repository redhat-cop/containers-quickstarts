FROM registry.access.redhat.com/ubi8/ubi:8.9-1160@sha256:edc34f89cf9c818c2fb28b8ea1780f384db563ce4293dc0ab8e73ec01791e5af

LABEL maintainer="Red Hat Services"

COPY requirements.txt /requirements.txt
RUN dnf update -y && \
    dnf install -y git python3.11 python3.11-pip python3.11-setuptools python3.11-numpy python3.11-scipy python3.11-six && \
    dnf clean all && \
    pip3.11 install --no-cache-dir -r /requirements.txt

# Copy in custom helper scripts
COPY ./root /
RUN chmod u+x /usr/local/bin/upload-file-to-google-drive
