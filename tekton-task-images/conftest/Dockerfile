FROM registry.access.redhat.com/ubi9/ubi-minimal:9.3-1361.1699548032@sha256:c77792b8084ce5946c68f39024fa460ef7769c0eef3fce995e70299e21a7e166

RUN microdnf install -y --nodocs tar gzip && \
    microdnf update -y && \
    microdnf clean all 

ADD VERSION /tmp/version
RUN source /tmp/version && \
    curl -LJO https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    tar -xzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    rm conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz

USER 1001
