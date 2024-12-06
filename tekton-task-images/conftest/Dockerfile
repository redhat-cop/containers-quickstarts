# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.5-1732804088@sha256:1057dab827c782abcfb9bda0c3900c0966b5066e671d54976a7bcb3a2d1a5e53 AS builder

SHELL ["/bin/bash", "-c"]

COPY VERSION /tmp/version
RUN source /tmp/version && \
    curl -L "https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    conftest --version

# Runnable
FROM registry.access.redhat.com/ubi9/ubi-micro:9.4-9@sha256:2044e2ca8e258d00332f40532db9f55fb3d0bfd77ecc84c4aa4c1b7af3626ffb

COPY --from=builder /usr/local/bin/conftest /usr/local/bin/conftest