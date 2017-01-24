FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7

MAINTAINER Johnathan Kupferer <jkupfere@redhat.com>

LABEL com.redhat.component="jenkins-slave-ansible-stacks" \
      name="jenkins-slave-ansible-stacks" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Slave Ansible Stacks" \
      io.k8s.description="Ansible and ansible-stacks on top of the jenkins slave base image" \
      io.openshift.tags="openshift,jenkins,slave,copy"

USER root

RUN yum --enablerepo ${ANSIBLE_YUM_REPO} install -y \
      ansible \
    yum clean all && \
    git clone ${ANSIBLE_STACKS_SOURCE_REPOSITORY_URL} /opt/ansible-stacks && \
    git checkout ${ANSIBLE_STACKS_SOURCE_REPOSITORY_REF}

USER 1001
