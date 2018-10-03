FROM openshift/jenkins-slave-base-centos7:latest

ENV ANSIBLE_VERSION=2.5.8 \
    ANSIBLE_REVISION=1

RUN INSTALL_PKGS="python2-pip" && \
    yum install -y epel-release && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS \
      https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-${ANSIBLE_VERSION}-${ANSIBLE_REVISION}.el7.ans.noarch.rpm && \
    rpm -V ansible && \
    yum clean all -y && \
    rm -rf /var/cache/yum

USER 1001
