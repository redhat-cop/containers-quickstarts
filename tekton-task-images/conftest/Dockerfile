FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3

RUN microdnf install --assumeyes --nodocs tar gzip && \
    microdnf clean all 

ADD VERSION /tmp/version
RUN source /tmp/version && \
    curl -LJO https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    tar -xzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    rm conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz
