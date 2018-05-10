FROM openshift/jenkins-slave-base-centos7:latest

USER root

COPY mongodb-org-3.6.repo /etc/yum.repos.d/

RUN yum install -y mongodb-org-tools mongodb-org-shell

USER 1001
