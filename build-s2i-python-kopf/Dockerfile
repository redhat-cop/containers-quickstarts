FROM registry.access.redhat.com/ubi8/python-39:latest

MAINTAINER Johnathan Kupferer <jkupfere@redhat.com>

ENV OPENSHIFT_CLIENT_VERSION=4.10.9 \
    HELM_VERSION=3.8.2

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
    curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_CLIENT_VERSION}/openshift-client-linux-${OPENSHIFT_CLIENT_VERSION}.tar.gz \
    | tar zxf - -C /usr/local/bin oc kubectl && \
    curl -s https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    | tar zxf - -C /usr/local/bin --strip-components=1 linux-amd64/helm && \
    chmod --recursive g+w /opt/app-root /usr/local && \
    chown --recursive 1001:0 /opt/app-root /usr/local && \
    mkdir -p /opt/app-root/nss && \
    chmod g+w /opt/app-root/nss

USER 1001

CMD ["usage"]
