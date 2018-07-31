FROM openshift/jenkins-slave-base-centos7

ENV REBAR3_VERSION=3.6.1

COPY erlang.repo /etc/yum.repos.d/erlang.repo
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y --setopt=tsflags=nodocs esl-erlang && \
    curl -Lo /usr/local/bin/rebar3 https://github.com/erlang/rebar3/releases/download/${REBAR3_VERSION}/rebar3 && \
    chmod +x /usr/local/bin/rebar3 && \
    yum clean all -y

USER 1001
