FROM quay.io/openshift/origin-jenkins-agent-base:4.14@sha256:1284ffe5b63ee7da4c4463d5f44b471fd42ce01c06f5c72edc195a30dcc1f7f4

# renovate: datasource=pypi depName=ansible-core
ARG ANSIBLE_CORE_VERSION=2.16.2

LABEL \
      release="1" \
      version="4.14" \
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
        ansible-core==${ANSIBLE_CORE_VERSION} \
"
ARG DNF_PKGS="python311"

ADD ubi8.repo /tmp/ubi8.repo

RUN set -x \
     && rm -f /etc/yum.repos.d/*.repo \
     && mv /tmp/ubi8.repo /etc/yum.repos.d/ \
     && dnf install ${DNF_FLAGS} ${DNF_PKGS} \
     && dnf ${DNF_FLAGS} clean all \
     && rm -rf /var/cache/dnf \
     && alternatives --set python3 /usr/bin/python3.11 \
     && python3 -m ensurepip --default-pip  \
     && python3 -m pip install --upgrade pip  \
     && python3 -m pip install ${PIP_PKGS} \
     && chmod -R 775 /etc/alternatives \
     && chmod -R 775 /var/lib/alternatives \
     && echo

USER 1001
ENV \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
