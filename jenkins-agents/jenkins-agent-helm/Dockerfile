FROM quay.io/openshift/origin-jenkins-agent-base:4.6

ARG VERSION=3.2.0
ARG YQ_VERSION=v4.5.1
ARG CT_VERSION=3.0.0-rc.1
ARG OPENSHIFT_CLIENT_VERSION=4.4.13

## Required in order to avoid ct "ascii codec can't encode character" error
ENV PYTHONIOENCODING=utf-8

COPY ubi8.repo /tmp/

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

## Install git, python 3.8, yamale, and yamllint
RUN INSTALL_PKGS="git python38 python38-pip" && \
    rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d/ubi8.repo && \
    dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    dnf -y clean all && \
    alternatives --set python3 /usr/bin/python3.8 && \
    python3 -m pip install yamale==3.0.1 && \
    python3 -m pip install yamllint==1.24.1

## Install oc and kubectl
RUN curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OPENSHIFT_CLIENT_VERSION}/openshift-client-linux-${OPENSHIFT_CLIENT_VERSION}.tar.gz \
    | tar zxf - -C /usr/local/bin oc kubectl 

USER 1001
