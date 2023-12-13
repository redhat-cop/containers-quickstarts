FROM quay.io/openshift/origin-jenkins-agent-maven:4.14@sha256:4a8671c25216b1b44bf47a363ec37d503568fa2f75ef1a010e2284ac1cc5df46

ARG GRAAL_VERSION=20.3.3.0-Final
ENV GRAALVM_HOME=/opt/mandrelJDK
ENV GRAAL_CE_URL=https://github.com/graalvm/mandrel/releases/download/mandrel-${GRAAL_VERSION}/mandrel-java11-linux-amd64-${GRAAL_VERSION}.tar.gz
# renovate: datasource=github-releases depName=helm/helm
ARG HELM_VERSION=v3.6.3
# renovate: datasource=github-releases depName=stedolan/jq
ARG JQ_VERSION=1.6
# renovate: datasource=repology depName=homebrew/openshift-cli
ARG OC_VERSION=4.8.0
# renovate: datasource=github-releases depName=mikefarah/yq
ARG YQ_VERSION=v4.11.2

ADD settings.xml $HOME/.m2/settings.xml
ADD ubi8.repo /tmp/ubi8.repo

USER root
RUN rm -f /etc/yum.repos.d/*.repo && \
    mv /tmp/ubi8.repo /etc/yum.repos.d/ubi8.repo && \
    dnf -y update --allowerasing && \
    dnf install -y gcc gcc-c++ glibc-static glibc-devel zlib-devel && \
    ### tools
    mkdir -p ${GRAALVM_HOME} && \
    cd ${GRAALVM_HOME} && \
    curl -fsSL $GRAAL_CE_URL | tar -xzC ${GRAALVM_HOME} --strip-components=1 && \
    curl -Lo /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 && \
    chmod +x /usr/local/bin/jq && \
    curl -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar --strip-components=1 -C /usr/local/bin -xzf - linux-amd64/helm && \
    curl -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    rm -f /usr/bin/oc && \
    curl -sL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz \
    | tar zxf - -C /usr/local/bin oc kubectl && \
    ### Cleanup
    dnf clean all && \
    rm -rf /var/cache/yum

USER 1001
WORKDIR ${USER_HOME_DIR}
ENV PATH ${PATH}:${GRAALVM_HOME}/bin
