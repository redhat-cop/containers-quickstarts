# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.8-1787634763@sha256:b8c53f907b7ea8934d6bb23b319ca7b5ab567e61a0806ffc80170631cabc7563 AS builder

SHELL ["/bin/bash", "-c"]

COPY VERSION /tmp/version
RUN source /tmp/version && \
    curl -L "https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz" -o /tmp/conftest.tar.gz && \
    tar -xzf /tmp/conftest.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    conftest --version

# Runnable
FROM registry.access.redhat.com/ubi9/ubi-micro:9.5-1746002938@sha256:839f16991579b023d4452eadd0efa925e438f8b73063afe4f75bdc6cf7a09b12

COPY --from=builder /usr/local/bin/conftest /usr/local/bin/conftest