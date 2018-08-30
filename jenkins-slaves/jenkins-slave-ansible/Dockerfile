FROM openshift3/jenkins-slave-base-rhel7:latest

USER root

RUN yum install -y --setopt=tsflags=nodocs \
      --disablerepo=* --enablerepo=rhel-7-server-rpms --enablerepo=rhel-7-server-extras-rpms \
      https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.5.8-1.el7.ans.noarch.rpm && \
    rpm -V ansible && \
    yum clean all -y && \
    rm -rf /var/cache/yum

USER 1001
