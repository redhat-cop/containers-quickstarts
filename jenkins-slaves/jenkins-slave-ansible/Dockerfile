FROM quay.io/openshift/origin-jenkins-agent-base:4.1

LABEL com.redhat.component="jenkins-agent-ansible-ubi7-docker" \
      name="openshift/origin-jenkins-agent-ansible-ubi7" \
      version="4.1" \
      architecture="x86_64" \
      release="1" \
      io.k8s.display-name="Jenkins Agent Ansible" \
      io.k8s.description="The jenkins agent ansible image has ansible on top of the jenkins agent base image." \
      io.openshift.tags="openshift,jenkins,agent,ansible"

ENV ANSIBLE_VERSION=2.8.2

ADD ubi.repo /etc/yum.repos.d/ubi.repo

RUN INSTALL_PKGS="rh-python36-python-pip" && \
    DISABLE_REPOS=--disablerepo='rhel-*' && \
    yum $DISABLE_REPOS install -y $INSTALL_PKGS && \
    source scl_source enable rh-python36 && \
    scl enable rh-python36 bash && \
    python3 -m pip install ansible==$ANSIBLE_VERSION paramiko && \
    yum $DISABLE_REPOS clean all -y && \
    rm -rf /var/cache/yum

ADD scl_enable /usr/share/container-scripts/
ENV BASH_ENV=/usr/share/container-scripts/scl_enable \
    ENV=/usr/share/container-scripts/scl_enable \
    PROMPT_COMMAND=". /usr/share/container-scripts/scl_enable"

USER 1001
