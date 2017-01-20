FROM registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7

MAINTAINER Johnathan Kupferer <jkupfere@redhat.com>

LABEL com.redhat.component="jenkins-slave-ansible-stacks" \
      name="jenkins-slave-ansible-stacks" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Slave Ansible Stacks" \
      io.k8s.description="Ansible and ansible-stacks on top of the jenkins slave base image" \
      io.openshift.tags="openshift,jenkins,slave,copy"

USER root

RUN yum --enablerepo rhel-7-server-ose-3.3-rpms install -y \
      ansible \
      atomic-openshift-clients \
      git && \
    yum clean all && \
    git clone https://github.com/rht-labs/ansible-stacks.git /opt/ansible-stacks

USER 1001
