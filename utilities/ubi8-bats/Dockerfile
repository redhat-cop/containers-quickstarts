FROM registry.access.redhat.com/ubi8/ubi-minimal

LABEL io.k8s.description="OCP Bats"
LABEL io.k8s.display-name="OCP Bats"

ARG BATS_VERSION=master
ARG HELM_VERSION=3.2.1
ARG JQ_VERSION=1.6
ARG OC_VERSION=4.4
ARG YQ_VERSION=3.3.0

RUN microdnf install -y gzip tar ncurses && \
    microdnf clean all && \
    curl -L https://github.com/bats-core/bats-core/archive/${BATS_VERSION}.tar.gz | tar -C /tmp -xzf - && \
    /tmp/bats-core-${BATS_VERSION}/install.sh /opt/bats && \
    rm -rf /tmp/bats-core-${BATS_VERSION} && \
    ln -s /opt/bats/bin/bats /usr/local/bin/bats && \
    curl -Lo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar --strip-components=1 -C /usr/local/bin -xzf - linux-amd64/helm && \
    curl -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    curl -L http://mirror.openshift.com/pub/openshift-v4/clients/oc/${OC_VERSION}/linux/oc.tar.gz | tar -C /usr/local/bin -xzf - && \
    mkdir -p /code

WORKDIR /code
USER 1001
ENTRYPOINT ["bats"]
