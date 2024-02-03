FROM registry.access.redhat.com/ubi8/ubi:8.9-1107.1706791207@sha256:627867e53ad6846afba2dfbf5cef1d54c868a9025633ef0afd546278d4654eac

LABEL maintainer="Red Hat Services"

COPY requirements.txt /requirements.txt
RUN dnf update -y && \
    dnf install -y git python3.11 python3.11-pip python3.11-setuptools python3.11-numpy python3.11-scipy python3.11-six && \
    dnf clean all && \
    pip3.11 install --no-cache-dir -r /requirements.txt

# Copy in custom helper scripts
COPY ./root /
RUN chmod u+x /usr/local/bin/upload-file-to-google-drive
