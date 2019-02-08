FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7:v3.11

MAINTAINER Andrew Block <ablock@redhat.com>

LABEL com.redhat.component="jenkins-slave-image-mgmt" \
      name="jenkins-slave-image-mgmt" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Slave Image Management" \
      io.k8s.description="Image management tools on top of the jenkins slave base image" \
      io.openshift.tags="openshift,jenkins,slave,copy"
USER root

RUN INSTALL_PKGS="skopeo" && \
    yum install -y --setopt=tsflags=nodocs \
      --enablerepo=rhel-7-server-rpms \
      --enablerepo=rhel-7-server-extras-rpms \
      $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

USER 1001
