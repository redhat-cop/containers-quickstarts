FROM registry.access.redhat.com/ubi9/python-312:latest@sha256:1d8846b7c6558a50b434f1ea76131f200dcdd92cfaf16b81996003b14657b491

MAINTAINER Johnathan Kupferer <jkupfere@redhat.com>

ENV OPENSHIFT_CLIENT_VERSION=4.14.43 \
    HELM_VERSION=3.16.2

LABEL io.k8s.description="Python Kopf - Kubernetes Operator Framework" \
      io.k8s.display-name="Kopf Operator" \
      io.openshift.tags="builder,python,kopf" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url=image:///usr/libexec/s2i

USER 0

COPY install/ /opt/app-root/install
COPY s2i /usr/libexec/s2i

# Specify the ports the final image will expose
EXPOSE 8080

RUN pip3 install --upgrade -r /opt/app-root/install/requirements.txt && \
    echo "Installing OpenShift command line client ${OPENSHIFT_CLIENT_VERSION}" && \
    curl -L --silent --show-error https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_CLIENT_VERSION}/openshift-client-linux.tar.gz --output openshift-client.tar.gz && \
    ls -l openshift-client.tar.gz && \
    tar zxf openshift-client.tar.gz -C /usr/local/bin oc kubectl && \
    rm openshift-client.tar.gz && \
    echo "Installing Helm command line ${HELM_VERSION}" && \
    curl -L --silent --show-error https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz --output helm.tar.gz && \
    tar zxf helm.tar.gz -C /usr/local/bin --strip-components=1 linux-amd64/helm && \
    rm helm.tar.gz && \
    chmod --recursive g+w /opt/app-root /usr/local && \
    chown --recursive 1001:0 /opt/app-root /usr/local && \
    mkdir -p /opt/app-root/nss && \
    chmod g+w /opt/app-root/nss

USER 1001

CMD ["usage"]
