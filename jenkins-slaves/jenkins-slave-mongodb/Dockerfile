FROM openshift/jenkins-slave-base-centos7:v3.11

USER root

COPY mongodb-org-3.6.repo /etc/yum.repos.d/

RUN yum install -y mongodb-org-tools mongodb-org-shell  && \
    yum clean all -y && \
    rm -rf /var/cache/yum

USER 1001
