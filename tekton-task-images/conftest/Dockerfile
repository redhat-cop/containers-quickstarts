# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.5-1744101466@sha256:ea57285741f007e83f2ee20423c20b0cbcce0b59cc3da027c671692cc7efe4dd AS builder

SHELL ["/bin/bash", "-c"]

COPY VERSION /tmp/version
RUN source /tmp/version && \
    curl -L "https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    conftest --version

# Runnable
FROM registry.access.redhat.com/ubi9/ubi-micro:9.5-1745845480@sha256:6bda78be9e26f3f5ebff94076e1a1c4deb3698b9aa8809e9e4a3d5140b5922a5

COPY --from=builder /usr/local/bin/conftest /usr/local/bin/conftest