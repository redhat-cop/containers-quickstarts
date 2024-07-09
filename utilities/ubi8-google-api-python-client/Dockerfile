FROM registry.access.redhat.com/ubi8/ubi:8.10-1020@sha256:44d75007b39e0e1bbf1bcfd0721245add54c54c3f83903f8926fb4bef6827aa2

LABEL maintainer="Red Hat Services"

COPY requirements.txt /requirements.txt
RUN dnf update -y && \
    dnf install -y git python3.11 python3.11-pip python3.11-setuptools python3.11-numpy python3.11-scipy python3.11-six && \
    dnf clean all && \
    pip3.11 install --no-cache-dir -r /requirements.txt

# Copy in custom helper scripts
COPY ./root /
RUN chmod u+x /usr/local/bin/upload-file-to-google-drive
