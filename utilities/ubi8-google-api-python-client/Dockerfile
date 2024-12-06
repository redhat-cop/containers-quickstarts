FROM registry.access.redhat.com/ubi8/ubi:8.10-1132.1732635159@sha256:79d46e7029c2b13a713b2089650fd235aadb3e6e449c79f6741d6c9381ab41a1

LABEL maintainer="Red Hat Services"

COPY requirements.txt /requirements.txt
RUN dnf update -y && \
    dnf install -y git python3.11 python3.11-pip python3.11-setuptools python3.11-numpy python3.11-scipy python3.11-six && \
    dnf clean all && \
    pip3.11 install --no-cache-dir -r /requirements.txt

# Copy in custom helper scripts
COPY ./root /
RUN chmod u+x /usr/local/bin/upload-file-to-google-drive
