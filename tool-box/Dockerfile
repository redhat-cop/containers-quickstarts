FROM registry.access.redhat.com/ubi8

MAINTAINER Aly Ibrahim<aly@redhat.com>

ENV OC_VERSION=4.4.7 \
    ODO_VERSION=v1.2.1 \
    ANSIBLE_VERSION=2.9 \
    JQ_VERSION=1.6 \
    HELM_VERSION=v3.2.1 \
    TEKTON_VERSION=0.9.0 \
    HOME=/home/tool-box

RUN yum -y update && \
    INSTALL_PKGS="git vim unzip python36" && \
    yum -y install $INSTALL_PKGS && \
    yum clean all

RUN curl -o jq --fail -sL https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x jq && \
    mv jq /usr/local/bin

RUN mkdir -m 775 $HOME && \
    chmod 775 /etc/passwd && \
    pip3 install git+https://github.com/ansible/ansible.git@stable-${ANSIBLE_VERSION}

RUN curl --fail -s https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar -xvz && \
    chmod u+x linux-amd64/helm && mv linux-amd64/helm /usr/local/bin/ && rm -rf linux-amd64

RUN curl --fail -sL https://github.com/tektoncd/cli/releases/download/v${TEKTON_VERSION}/tkn_${TEKTON_VERSION}_Linux_x86_64.tar.gz | tar --no-same-owner -xvz -C /usr/local/bin/ tkn

RUN curl --fail -sL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux-${OC_VERSION}.tar.gz | tar -C /usr/local/bin/ -xzf -

RUN curl --fail -sL https://mirror.openshift.com/pub/openshift-v4/clients/odo/${ODO_VERSION}/odo-linux-amd64 -o /usr/local/bin/odo && \
    chmod +x /usr/local/bin/odo

WORKDIR $HOME

ADD ./root /

RUN chmod u+x /usr/local/bin/run && \
    chown -R 1001:1001 $HOME

USER 1001

ENTRYPOINT ["/usr/local/bin/run"]
CMD ["sleep", "infinity"]
