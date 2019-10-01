FROM image-registry.openshift-image-registry.svc:5000/openshift/nexus-repository-manager
LABEL maintainer="Deven Phillips <deven.phillips@redhat.com>" \
      vendor="Red Hat Containers And PaaS Community of Practice" \
      description="Sonatype Nexus repository manager with Kubernetes/OpenShift Config plugin" \
      source="https://github.com/InfoSec812/nexus-kubernetes-openshift" \
      documentation="https://github.com/InfoSec812/nexus-kubernetes-openshift/blob/master/README.md"
ARG PLUGIN_VERSION=0.2.7

USER root
ADD https://github.com/InfoSec812/nexus-kubernetes-openshift/releases/download/v${PLUGIN_VERSION}/nexus-openshift-plugin-${PLUGIN_VERSION}.jar /opt/sonatype/nexus/deploy/nexus-openshift-plugin.jar
RUN sed -i 's@startLocalConsole=false@startLocalConsole=true@g' /opt/sonatype/nexus/bin/nexus.vmoptions \
    && chown nexus:nexus /opt -R \
    && chown nexus:nexus /nexus-data -R \
    && chmod 775 /opt -R \
    && chmod 775 /nexus-data -R
USER 1001