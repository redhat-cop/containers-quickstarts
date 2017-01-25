FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7

MAINTAINER Johnathan Kupferer <jkupfere@redhat.com>

LABEL com.redhat.component="jenkins-slave-ansible-stacks" \
      name="jenkins-slave-ansible-stacks" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Slave Ansible Stacks" \
      io.k8s.description="Ansible and ansible-stacks on top of the jenkins slave base image" \
      io.openshift.tags="openshift,jenkins,slave,copy"

USER root

ENV ANSIBLE_YUM_REPO=${ANSIBLE_YUM_REPO:-rhel-7-server-ose-3.3-rpms} \
    ANSIBLE_STACKS_SOURCE_REPOSITORY_URL=${ANSIBLE_STACKS_SOURCE_REPOSITORY_URL:-https://github.com/rht-labs/ansible-stacks.git} \
    ANSIBLE_STACKS_SOURCE_REPOSITORY_REF=${ANSIBLE_STACKS_SOURCE_REPOSITORY_REF:-master}

RUN yum --enablerepo ${ANSIBLE_YUM_REPO} install -y \
      ansible \
    yum clean all && \
    git clone ${ANSIBLE_STACKS_SOURCE_REPOSITORY_URL} /opt/ansible-stacks && \
    cd /opt/ansible-stacks && \
    git checkout ${ANSIBLE_STACKS_SOURCE_REPOSITORY_REF}

USER 1001
