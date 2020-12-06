FROM quay.io/openshift/origin-jenkins-agent-base:4.6
ARG ANSIBLE_VERSION=2.9.13

LABEL \
      release="1" \
      version="4.6" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Agent Ansible" \
      name="openshift/origin-jenkins-agent-ansible-ubi7" \
      io.openshift.tags="openshift,jenkins,agent,ansible" \
      com.redhat.component="jenkins-agent-ansible-ubi7-docker" \
      io.k8s.description="The jenkins agent ansible image has ansible on top of the jenkins agent base image."

ARG DISABLE_REPOS=--disablerepo="rhel-*"
ARG YUM_FLAGS="${DISABLE_REPOS} -y -q"

ARG PIP_PKGS="\
        molecule \
        paramiko \
        openshift \
        kubernetes \
        ansible==${ANSIBLE_VERSION} \
"
ARG YUM_PKGS="\
        rh-python36-python-pip \
"

ADD ubi.repo /etc/yum.repos.d/ubi.repo
ADD scl_enable /usr/share/container-scripts/

USER root
RUN set -x \
     && yum install ${YUM_FLAGS} ${YUM_PKGS} \
     && yum ${YUM_FLAGS} clean all \
     && rm -rf /var/cache/yum \
     && source scl_source enable rh-python36 \
     && python3 -m pip install ${PIP_PKGS} \
    && echo

USER 1001
ENV \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    ENV=/usr/share/container-scripts/scl_enable \
    BASH_ENV=/usr/share/container-scripts/scl_enable \
    PROMPT_COMMAND="./usr/share/container-scripts/scl_enable"
