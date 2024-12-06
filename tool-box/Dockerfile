# Builder
FROM registry.access.redhat.com/ubi9/ubi:9.4-1123.1719560047@sha256:081c96d1b1c7cd1855722d01f1ca53360510443737b1eb33284c6c4c330e537c AS builder

SHELL ["/bin/bash", "-c"]

# renovate: datasource=repology depName=homebrew/openshift-cli
ARG OC_VERSION=4.16.10
# renovate: datasource=github-releases depName=openshift/rosa
ARG ROSA_VERSION=v1.2.48
# renovate: datasource=github-releases depName=redhat-developer/odo
ARG ODO_VERSION=v3.16.1
# renovate: datasource=github-releases depName=stedolan/jq
ARG JQ_VERSION=1.6
# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=v3.16.1
# renovate: datasource=github-releases depName=tektoncd/cli
ARG TEKTON_VERSION=v0.39.0
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=4.44.3

RUN curl -L "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz" -o /tmp/openshift-client-linux.tar.gz && \
    tar --no-same-owner -xzf /tmp/openshift-client-linux.tar.gz && \
    mv oc kubectl /usr/local/bin && \
    oc version --client && \
    kubectl version --client

RUN curl -L "https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/rosa/${ROSA_VERSION//v}/rosa-linux.tar.gz" -o /tmp/rosa-linux.tar.gz && \
    tar --no-same-owner -xzf /tmp/rosa-linux.tar.gz && \
    mv rosa /usr/local/bin && \
    rosa version

RUN curl -L "https://mirror.openshift.com/pub/openshift-v4/clients/odo/${ODO_VERSION}/odo-linux-amd64" -o /usr/local/bin/odo && \
    chmod +x /usr/local/bin/odo && \
    odo version --client

RUN curl -L "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" -o /usr/local/bin/jq  && \
    chmod +x /usr/local/bin/jq && \
    jq --version

RUN curl -L "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" -o /usr/local/bin/yq && \
    chmod +x /usr/local/bin/yq && \
    yq --version

RUN curl -L "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tar.gz && \
    tar -xzf /tmp/helm.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    helm version

RUN curl -L "https://github.com/tektoncd/cli/releases/download/${TEKTON_VERSION}/tkn_${TEKTON_VERSION//v}_Linux_x86_64.tar.gz" -o /tmp/tkn.tar.gz && \
    tar --no-same-owner -xzf /tmp/tkn.tar.gz && \
    mv tkn /usr/local/bin && \
    tkn version

# Runnable
FROM registry.access.redhat.com/ubi9/ubi:9.4-1123.1719560047@sha256:081c96d1b1c7cd1855722d01f1ca53360510443737b1eb33284c6c4c330e537c

ENV HOME=/home/tool-box

COPY requirements.txt /requirements.txt
RUN dnf -y update && \
    dnf -y install git iputils net-tools procps-ng python3.11 python3.11-pip vim unzip zip && \
    dnf clean all && \
    pip3.11 install --no-cache-dir -r /requirements.txt && \
    ansible --version

COPY --from=builder /usr/local/bin/oc /usr/local/bin/oc
COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=builder /usr/local/bin/rosa /usr/local/bin/rosa
COPY --from=builder /usr/local/bin/odo /usr/local/bin/odo
COPY --from=builder /usr/local/bin/jq /usr/local/bin/jq
COPY --from=builder /usr/local/bin/yq /usr/local/bin/yq
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/local/bin/tkn /usr/local/bin/tkn

RUN curl -L https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin && \
    rm -rf awscliv2.zip aws && \
    aws --version

WORKDIR $HOME

COPY ./root /
RUN mkdir -m 775 -p $HOME && \
    chmod 775 /etc/passwd && \
    chmod u+x /usr/local/bin/run

USER 1001

ENTRYPOINT ["/usr/local/bin/run"]
CMD ["sleep", "infinity"]
