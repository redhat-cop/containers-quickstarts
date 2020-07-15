FROM quay.io/openshift/origin-jenkins-agent-base:4.4

ARG VERSION=3.2.0 
ARG YQ_VERSION=3.3.0
ARG CT_VERSION=3.0.0-rc.1
ARG GIT_VERSION=2.24.1
ARG OPENSHIFT_CLIENT_VERSION=4.4.13

## Required in order to avoid ct "ascii codec can't encode character" error
ENV PYTHONIOENCODING=utf-8

COPY ubi.repo /etc/yum.repos.d/

## Install helm and yq
RUN curl -skL -o /tmp/helm.tar.gz https://get.helm.sh/helm-v${VERSION}-linux-amd64.tar.gz && \ 
    tar -C /tmp -xzf /tmp/helm.tar.gz && \
    mv /tmp/linux-amd64/helm /usr/local/bin && \
    chmod -R 775 /usr/local/bin/helm && \
    rm -rf /tmp/helm.tar.gz && \
    rm -rf /tmp/linux-amd64 && \
    curl -sL  https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod -R 775 /usr/local/bin/yq

## Install ct
RUN curl -sL -o /tmp/chart-testing.tar.gz https://github.com/helm/chart-testing/releases/download/v${CT_VERSION}/chart-testing_${CT_VERSION}_linux_amd64.tar.gz && \
    mkdir /tmp/chart-testing && \
    tar -C /tmp/chart-testing -zxf /tmp/chart-testing.tar.gz && \
    mv /tmp/chart-testing/ct /usr/local/bin && \
    chmod 775 /usr/local/bin/ct && \
    rm /tmp/chart-testing.tar.gz && \
    mkdir ${HOME}/.ct && \
    mv /tmp/chart-testing/etc/chart_schema.yaml /tmp/chart-testing/etc/lintconf.yaml ${HOME}/.ct/ && \
    rm -rf /tmp/chart-testing

## Install python 3.6, yamale, and yamllint
RUN INSTALL_PKGS="rh-python36 rh-python36-python-pip" && \
    yum -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    yum -y clean all --enablerepo='*' && \
    source scl_source enable rh-python36 && \
    python3 -m pip install yamale==3.0.1 && \
    python3 -m pip install yamllint==1.24.1

## Persistently enable software collections
RUN mkdir /usr/share/container-scripts
COPY scl_enable /usr/share/container-scripts
RUN chmod 555 /usr/share/container-scripts/scl_enable
ENV BASH_ENV=/usr/share/container-scripts/scl_enable \
    ENV=/usr/share/container-scripts/scl_enable \
    PROMPT_COMMAND=". /usr/share/container-scripts/scl_enable"

## Install git > 2.17 (ubi repos don't provide this)
RUN yum -y remove git* && \
    yum -y install https://packages.endpoint.com/rhel/7/os/x86_64/endpoint-repo-1.8-1.x86_64.rpm && \
    yum -y --setopt=tsflags=nodocs install git-${GIT_VERSION}

## Install oc and kubectl
RUN curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_CLIENT_VERSION}/openshift-client-linux-${OPENSHIFT_CLIENT_VERSION}.tar.gz \
    | tar zxf - -C /usr/local/bin oc kubectl 

USER 1001
