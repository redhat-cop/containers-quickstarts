# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.3-1361.1699548029@sha256:6b95efc134c2af3d45472c0a2f88e6085433df058cc210abb2bb061ac4d74359 AS builder

SHELL ["/bin/bash", "-c"]

COPY VERSION /tmp/version
RUN source /tmp/version && \
    curl -L "https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    conftest --version

# Runnable
FROM registry.access.redhat.com/ubi9/ubi-micro:9.3-9@sha256:14a2cd49b11eb39586f5abdefc63739f47cd5b8099e0d6946d7ee24812e7e746

USER root

RUN microdnf update -y && \
    microdnf clean all

USER 1001

COPY --from=builder /usr/local/bin/conftest /usr/local/bin/conftest