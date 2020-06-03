#!/usr/bin/env bash

set -o errexit

BATS_VERSION=master
HELM_VERSION=3.2.1
JQ_VERSION=1.6
OC_VERSION=4.4
YQ_VERSION=3.3.0

container=$(buildah from registry.access.redhat.com/ubi8/ubi-minimal)
buildah config --label io.k8s.description="OCP Bats" --label io.k8s.display-name="OCP Bats" $container
buildah run $container -- bash -c 'microdnf install -y gzip tar ncurses && microdnf clean all'
buildah run $container -- bash -c "curl -L https://github.com/bats-core/bats-core/archive/${BATS_VERSION}.tar.gz | tar -C /tmp -xzf - && /tmp/bats-core-${BATS_VERSION}/install.sh /opt/bats && rm -rf /tmp/bats-core-${BATS_VERSION} && ln -s /opt/bats/bin/bats /usr/local/bin/bats"
buildah run $container -- bash -c "curl -Lo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && chmod +x /usr/local/bin/jq"
buildah run $container -- bash -c "curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar --strip-components=1 -C /usr/local/bin -xzf - linux-amd64/helm"
buildah run $container -- bash -c "curl -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 && chmod +x /usr/local/bin/yq"
buildah run $container -- bash -c "curl -L http://mirror.openshift.com/pub/openshift-v4/clients/oc/${OC_VERSION}/linux/oc.tar.gz | tar -C /usr/local/bin -xzf -"
buildah run $container -- mkdir -p /code
buildah config --user 1001:0 --workingdir /code --entrypoint '["bats"]' $container

buildah commit $container ubi-bats:latest
