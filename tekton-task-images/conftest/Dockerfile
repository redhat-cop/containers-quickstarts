FROM registry.access.redhat.com/ubi9/ubi-minimal:9.3-1475@sha256:a340f4b9fb261a75c84666a3dccb88e193a116da3cebabaf9bcdc33609b61172

RUN microdnf install -y --nodocs tar gzip && \
    microdnf update -y && \
    microdnf clean all 

ADD VERSION /tmp/version
RUN source /tmp/version && \
    curl -LJ -o conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz https://github.com/open-policy-agent/conftest/releases/download/${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION//v}_Linux_x86_64.tar.gz && \
    tar -xzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    mv conftest /usr/local/bin/conftest && \
    rm conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz

USER 1001
