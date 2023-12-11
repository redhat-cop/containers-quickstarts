FROM quay.io/openshift/origin-jenkins-agent-base:4.9@sha256:94025d11174dbf836427236733d1b82010a21cf83c5321ec168db761fc2c28e7
ARG ANSIBLE_VERSION=2.9.13

LABEL \
      release="1" \
      version="4.8" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Ansible" \
      name="openshift/origin-jenkins-agent-ansible-ubi8" \
      io.openshift.tags="openshift,jenkins,agent,ansible" \
      com.redhat.component="jenkins-agent-ansible-ubi8-docker" \
      io.k8s.description="The jenkins agent ansible image has ansible on top of the jenkins agent base image."

ARG DNF_FLAGS="-y"

ARG PIP_PKGS="\
        molecule \
        paramiko \
        openshift \
        kubernetes \
        ansible==${ANSIBLE_VERSION} \
"
ARG DNF_PKGS="\
        python38-pip \
"

ADD ubi8.repo /tmp/ubi8.repo

RUN set -x \
     && rm -f /etc/yum.repos.d/*.repo \
     && mv /tmp/ubi8.repo /etc/yum.repos.d/ \
     && dnf install ${DNF_FLAGS} ${DNF_PKGS} \
     && dnf ${DNF_FLAGS} clean all \
     && rm -rf /var/cache/dnf \
     && alternatives --set python3 /usr/bin/python3.8 \
     && python3 -m pip install ${PIP_PKGS} \
     && chmod -R 775 /etc/alternatives \
     && chmod -R 775 /var/lib/alternatives \
     && echo

USER 1001
ENV \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
