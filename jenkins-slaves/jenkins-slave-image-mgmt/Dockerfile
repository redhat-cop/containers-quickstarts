FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7

MAINTAINER Andrew Block <ablock@redhat.com>

LABEL com.redhat.component="jenkins-slave-image-mgmt" \
      name="jenkins-slave-image-mgmt" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Slave Image Management" \
      io.k8s.description="Image management tools on top of the jenkins slave base image" \
      io.openshift.tags="openshift,jenkins,slave,copy"

ENV SKOPEO_BIN=https://github.com/sabre1041/ocp-support-resources/blob/master/skopeo/bin/skopeo?raw=true

USER root

COPY etc/policy.json /etc/containers/

RUN curl -L -o /usr/bin/skopeo $SKOPEO_BIN && \
    chmod +x /usr/bin/skopeo && \
    chown -R 1001:0 /etc/containers $HOME /usr/bin/skopeo  && \
    chmod -R g+rw /etc/containers $HOME /usr/bin/skopeo

USER 1001
