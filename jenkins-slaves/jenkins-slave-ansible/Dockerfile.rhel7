FROM openshift3/jenkins-slave-base-rhel7:v3.11

LABEL com.redhat.component="jenkins-slave-ansible-rhel7-docker" \
      name="openshift3/jenkins-slave-ansible-rhel7" \
      version="3.11" \
      architecture="x86_64" \
      release="1" \
      io.k8s.display-name="Jenkins Slave Ansible" \
      io.k8s.description="The jenkins slave ansible image has ansible on top of the jenkins slave base image." \
      io.openshift.tags="openshift,jenkins,slave,ansible"

ENV ANSIBLE_VERSION=2.5.8 \
    ANSIBLE_REVISION=1

RUN INSTALL_PKGS="python2-pip" && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y --setopt=tsflags=nodocs \
      --disablerepo=* --enablerepo=rhel-7-server-rpms --enablerepo=rhel-7-server-extras-rpms \
      --enablerepo=epel $INSTALL_PKGS \
      https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-${ANSIBLE_VERSION}-${ANSIBLE_REVISION}.el7.ans.noarch.rpm && \
    rpm -V ansible && \
    yum clean all -y && \
    rm -rf /var/cache/yum

USER 1001
