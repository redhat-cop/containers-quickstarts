FROM registry.access.redhat.com/ubi8/s2i-core:latest
  
MAINTAINER Johnathan Kupferer <jkupfere@redhat.com>

ENV PYTHON_VERSION=3.8.2

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

RUN yum install -y \
      gcc \
      openssl-devel \
      bzip2-devel \
      libffi-devel \
      make \
      nss_wrapper \
    && \
    /opt/app-root/install/python3-install.sh && \
    pip3 install --upgrade -r /opt/app-root/install/requirements.txt && \
    chmod --recursive g+w /usr/local && \
    chown --recursive 1001:0 /usr/local && \
    mkdir -p /opt/app-root/nss && \
    chmod g+w /opt/app-root/nss

USER 1001

CMD ["usage"]
