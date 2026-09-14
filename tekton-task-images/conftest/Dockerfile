# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.5-1745854298@sha256:f4ebd46d3ba96feb016d798009e1cc2404c3a4ebdac8b2479a2ac053e59f41b4 AS builder

SHELL ["/bin/bash", "-c"]

COPY VERSION /tmp/version
RUN source /tmp/version && \
    curl -L "https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    conftest --version

# Runnable
FROM registry.access.redhat.com/ubi9/ubi-micro:9.8-1789345812@sha256:7a0454cbd9bd847e8f6a63b6f0254a6efbeb6e0ed71a5d824a4f6cccbe626650

COPY --from=builder /usr/local/bin/conftest /usr/local/bin/conftest