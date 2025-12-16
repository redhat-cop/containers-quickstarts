FROM registry.access.redhat.com/ubi8/ubi:8.10-1764070939@sha256:a444712276a635c9312d83a4ff7c6ee7f2ce08eeb5bd9ca291b5fdba257a5e63

LABEL maintainer="Red Hat Services"

COPY requirements.txt /requirements.txt
RUN dnf update -y && \
    dnf install -y git python3.11 python3.11-pip python3.11-setuptools python3.11-numpy python3.11-scipy python3.11-six && \
    dnf clean all && \
    pip3.11 install --no-cache-dir -r /requirements.txt

# Copy in custom helper scripts
COPY ./root /
RUN chmod u+x /usr/local/bin/upload-file-to-google-drive
