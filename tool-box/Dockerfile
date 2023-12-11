FROM registry.access.redhat.com/ubi8@sha256:449da7f8f2ef6285a8445a1e31af57a97b9dae5dcf009b1629c59742c89c68c3

ENV OC_VERSION=stable-4.12 \
    ROSA_VERSION=1.2.15 \
    ODO_VERSION=v3.9.0 \
    ANSIBLE_VERSION=2.14.5 \
    JQ_VERSION=1.6 \
    HELM_VERSION=v3.11.3 \
    TEKTON_VERSION=0.30.1 \
    HOME=/home/tool-box \
    INSTALL_PKGS="git iputils procps-ng python39 vim unzip zip"

RUN yum -y update && \
    yum -y install $INSTALL_PKGS && \
    yum clean all

RUN curl -o jq --fail -sL https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x jq && \
    mv jq /usr/local/bin

RUN mkdir -m 775 $HOME && \
    chmod 775 /etc/passwd && \
    pip3 install --upgrade pip && \
    pip3 install ansible-core==${ANSIBLE_VERSION} 

RUN curl --fail -s https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar -xvz && \
    chmod u+x linux-amd64/helm && mv linux-amd64/helm /usr/local/bin/ && rm -rf linux-amd64

RUN curl --fail -sL https://github.com/tektoncd/cli/releases/download/v${TEKTON_VERSION}/tkn_${TEKTON_VERSION}_Linux_x86_64.tar.gz | tar --no-same-owner -xvz -C /usr/local/bin/ tkn

RUN curl --fail -sL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz | tar -C /usr/local/bin/ -xzf -

RUN curl --fail -sL https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/rosa/${ROSA_VERSION}/rosa-linux.tar.gz | tar -C /usr/local/bin/ -xzf -

RUN curl --fail -sL https://mirror.openshift.com/pub/openshift-v4/clients/odo/${ODO_VERSION}/odo-linux-amd64 -o /usr/local/bin/odo && \
    chmod +x /usr/local/bin/odo

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin; \
    rm -rf awscliv2.zip aws

WORKDIR $HOME

ADD ./root /

RUN chmod u+x /usr/local/bin/run && \
    rm -rf $HOME/.cache

USER 1001

ENTRYPOINT ["/usr/local/bin/run"]
CMD ["sleep", "infinity"]
