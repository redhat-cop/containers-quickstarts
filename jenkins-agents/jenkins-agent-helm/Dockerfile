FROM quay.io/openshift/origin-jenkins-agent-base:4.8

ARG VERSION=3.5.2
ARG YQ_VERSION=v4.5.1
ARG CT_VERSION=3.3.1
ARG OPENSHIFT_CLIENT_VERSION=4.8
ARG CONFTEST_VERSION=0.23.0
ARG KUBE_LINTER_VERSION=0.2.3

## Required in order to avoid ct "ascii codec can't encode character" error
ENV PYTHONIOENCODING=utf-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8

COPY ubi8.repo /tmp/

## Install helm, yq, conftest & kube-linter
RUN curl -sL https://get.helm.sh/helm-v${VERSION}-linux-amd64.tar.gz | tar zxf - -C /usr/local/bin --strip-components=1 linux-amd64/helm && \
    curl -sL https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz | tar zxf - -C /usr/local/bin conftest && \
    curl -sL https://github.com/stackrox/kube-linter/releases/download/${KUBE_LINTER_VERSION}/kube-linter-linux.tar.gz | tar zxf - -C /usr/local/bin kube-linter && \
    curl -sL  https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -o /usr/local/bin/yq && \
    chmod -R 755 /usr/local/bin/yq

## Install ct
RUN curl -sL -o /tmp/chart-testing.tar.gz https://github.com/helm/chart-testing/releases/download/v${CT_VERSION}/chart-testing_${CT_VERSION}_linux_amd64.tar.gz && \
    mkdir ${HOME}/.ct && \
    tar zxf /tmp/chart-testing.tar.gz -C /usr/local/bin ct && \
    tar zxf /tmp/chart-testing.tar.gz -C ${HOME}/.ct --strip-components=1 etc && \
    rm /tmp/chart-testing.tar.gz

## Install git, python 3.8, yamale, and yamllint
RUN INSTALL_PKGS="git python38 python38-pip" && \
    rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d/ubi8.repo && \
    dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    dnf -y clean all && \
    alternatives --set python3 /usr/bin/python3.8 && \
    python3 -m pip install yamale==3.0.1 && \
    python3 -m pip install yamllint==1.24.1 && \
    chmod -R 775 /var/lib/alternatives && \
    chmod -R 775 /etc/alternatives

## Install oc and kubectl
RUN curl -sL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable-${OPENSHIFT_CLIENT_VERSION}/openshift-client-linux.tar.gz \
    | tar zxf - -C /usr/local/bin oc kubectl

USER 1001
