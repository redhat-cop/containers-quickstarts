FROM registry.access.redhat.com/ubi8:8.9-1028@sha256:449da7f8f2ef6285a8445a1e31af57a97b9dae5dcf009b1629c59742c89c68c3

ENV HOME=/home/tool-box \
    INSTALL_PKGS="git iputils procps-ng python311 vim unzip zip"

# renovate: datasource=repology depName=homebrew/openshift-cli
ENV OC_VERSION=4.14.3
# renovate: datasource=github-releases depName=openshift/rosa
ENV ROSA_VERSION=v1.2.15
# renovate: datasource=github-releases depName=redhat-developer/odo
ENV ODO_VERSION=v3.9.0
# renovate: datasource=pypi depName=ansible-core
ENV ANSIBLE_CORE_VERSION=2.14.5
# renovate: datasource=github-releases depName=stedolan/jq
ENV JQ_VERSION=1.6
# renovate: datasource=github-releases depName=helm/helm
ENV HELM_VERSION=v3.11.3
# renovate: datasource=github-releases depName=tektoncd/cli
ENV TEKTON_VERSION=v0.33.0

RUN yum -y update && \
    yum -y install $INSTALL_PKGS && \
    yum clean all

RUN curl -o jq --fail -sL https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x jq && \
    mv jq /usr/local/bin

RUN mkdir -m 775 $HOME && \
    chmod 775 /etc/passwd && \
    python3 -m ensurepip --default-pip && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install ansible-core==${ANSIBLE_CORE_VERSION}

RUN curl --fail -s https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar -xvz && \
    chmod u+x linux-amd64/helm && mv linux-amd64/helm /usr/local/bin/ && rm -rf linux-amd64

RUN curl --fail -sL https://github.com/tektoncd/cli/releases/download/${TEKTON_VERSION}/tkn_${TEKTON_VERSION//v}_Linux_x86_64.tar.gz | tar --no-same-owner -xvz -C /usr/local/bin/ tkn

RUN curl --fail -sL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz | tar --no-same-owner -C /usr/local/bin/ -xzf -

RUN curl --fail -sL https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/rosa/${ROSA_VERSION//v}/rosa-linux.tar.gz | tar --no-same-owner -C /usr/local/bin/ -xzf -

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
