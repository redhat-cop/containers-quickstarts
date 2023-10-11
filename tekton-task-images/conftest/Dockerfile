FROM registry.access.redhat.com/ubi9/ubi-minimal:9.1

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
