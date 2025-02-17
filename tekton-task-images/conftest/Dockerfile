# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.5-1739751568@sha256:d342aa80781bf41c4c73485c41d8f1e2dbc40ee491633d9cafe787c361dd44ff AS builder

SHELL ["/bin/bash", "-c"]

COPY VERSION /tmp/version
RUN source /tmp/version && \
    curl -L "https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    conftest --version

# Runnable
FROM registry.access.redhat.com/ubi9/ubi-micro:9.5-1733126338@sha256:a410623c2b8e9429f9606af821be0231fef2372bd0f5f853fbe9743a0ddf7b34

COPY --from=builder /usr/local/bin/conftest /usr/local/bin/conftest