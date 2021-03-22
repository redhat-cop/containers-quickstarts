FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3

USER root

RUN microdnf install --assumeyes --nodocs openssl tar gzip && \
    microdnf clean all

ADD VERSION /tmp/version
RUN source /tmp/version && \
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
  chmod 700 get_helm.sh && \
  ./get_helm.sh --version ${HELM_VERSION}

USER 1001